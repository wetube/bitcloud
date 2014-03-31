-- For more verbose documentation, see Bitcloud.org wiki --
-- http://bitcloudproject.org/w/Nodepool.sql_Database_Design --
-- All below SQL should be generic SQL --

/* Nodepool.sql Database

Rules:

 - Every record is owned by its creator, as enforced via synchronization
   verifying signature.

 - The only exception to the above is in the case of user files, which are
   owned by both the user and Publisher.

 - Every record may only be modified/deleted by its owner(s), but may be
   removed by anyone via "garbage collection" if its owner(s) have been
   banned.

 - SQLite supports DB functions/stored procedures written in C.  Those
   functions, therefore, will only be referenced hereing documentation
   provided in the sync and interface code elsewhere.

 */

PRAGMA foreign_keys = ON;

----------------------------
-- Bitcloud Nodepool Team --
----------------------------

-- general nodepool --

-- The contents of the general nodepool are synced globally across every nodes
-- in the Bitcloud network.

/*
 nodes table

 Contains: records of all nodes on the Bitcloud nework (up to 1.8e19)

 Rules:

 - Each node must sign its own entire row (except the signature field itself)
 using its own public key.

 - The node must provide a new signature of its row every 3 days
 maximum. Otherwise it is deleted from the nodepool and connections refused.

 - creation_date must be within the same synchronization period that the node
 is registered for node registration be valid.

 - Consistancy is checked by ensuring that nobody tries to register in other
   period that is not the actual:

*/

CREATE TABLE nodes (
 public_key BLOB PRIMARY KEY NOT NULL, -- ID
 proximity BLOB NOT NULL, -- DHT (kademlia-like) map coordinates
 signature BLOB NOT NULL,  -- self certificate of this row
 creation_date INTEGER NOT NULL,
 proof_of_creation BLOB, -- see CA generation in the protocol spec
 net_protocol INTEGER DEFAULT 1, -- 1 IP, 2 Tor
 address TEXT NOT NULL -- IP or onion address
);


-- A grid is a collection of nodes associated that can sell
-- space and bandwidth to a publisher
CREATE TABLE grids (
 id BLOB PRIMARY KEY NOT NULL, -- random number
 owner_id BLOB NOT NULL REFERENCES nodes(public_key),
 signature BLOB NOT NULL -- signature of the owner
);


CREATE TABLE publishers (
 public_key PRIMARY KEY NOT NULL,
 address TEXT ,
 creation_date DATE DEFAULT CURRENT_TIMESTAMP NOT NULL,
 proof_of_creation, -- see CA generation in the protocol spec
 nickname TEXT,
 -- is information about the content of this publisher public?:
 public_metadata BOOLEAN DEFAULT FALSE,
 public_files BOOLEAN DEFAULT FALSE,
 -- trust all other publisher users by default? If not, only trust
 -- those in the publisher_trusts with positive trust. If yes, trust
 -- all except those with negative trust.
 trust_all_users BOOLEAN DEFAULT TRUE
);



-------------------------------------
-- internal publishers/grid tables --
-------------------------------------

-- these tables are shared between associations (e.g., between publishers and
-- grids, or grids and nodes, etc.)

/*

 node_audit table: things in this table are only inserted after a node failed
 to provide a correct check. Every single row in this table is deleted after
 every check period, and the new content based on the last one, so it can
 ensure continuation of the measurements and save space at the same time.

 For example, if a node fails to be available for some periods, there is no
 need that the nodes doing the check have to insert new rows, they just reuse
 the rows from the previous perirods, and sign the row. The limit is 16 rows
 per node.

 Auditors are random.

 Nodes doing everything perfect are never present in this table except when
 issued by malicious nodes. The majority of the net must be malicious in order
 to have consecuences for those nodes.

 Bitcloud do not count reputation, but just measures possible incorrections of
 the nodes. DAs on top could implement a system of reputation based on this
 table and other tables they provide.

*/


CREATE TABLE publisher_trusts (
 from_publisher NOT NULL REFERENCES publishers(public_key),
 to_publisher REFERENCES publishers(public_key),
 trust_users BOOLEAN NOT NULL,
 trust_powers BOOLEAN NOT NULL, -- like baning users or moderate files
 signature NOT NULL, -- from signature
 reason REFERENCES reason(id) NOT NULL
);


CREATE TABLE users (
 public_key PRIMARY KEY NOT NULL,
 publisher NOT NULL REFERENCES publishers(public_key),
 publisher_signature,
 address TEXT,
 nick TEXT COLLATE NOCASE,
 fixed_address BOOLEAN DEFAULT TRUE,
 revocation_date DATE DEFAULT CURRENT_TIMESTAMP,
 storage_quota INTEGER DEFAULT 0,
 bandwidth_quota INTEGER DEFAULT 0,
 files_quota INTEGER DEFAULT 0, -- how many files can upload
 folder_quota INTEGER DEFAULT 0, -- how many folders allowed
 root_folder REFERENCES folders(id)
);

-- User requests sent to the grids, for example, creating
-- a folder or uploading/downloading a file
CREATE TABLE user_requests (
 id BLOB PRIMARY KEY NOT NULL,
 user BLOB NOT NULL REFERENCES users(public_key),
 signature BLOB NOT NULL,
 grid TEXT NOT NULL REFERENCES grids(public_key),
 action INTEGER NOT NULL,
 -- every type of action will have a different param values
 param1,
 param2,
 /*
 1: Download file: param1=fileID, param2=offset
 2: Stream file: param1=fileID, param2=offset
 3: Upload file: param1=fileID, param2=folderID
 4: Create folder: param1=folderID
 5: Remove folder: param1=folderID
 6: Rename folder: param1=folderID
 7: Move file: param1=origin_foldeID, param2=final_folderID
 8: Rename file: param1=fileID, param2=new_name
 9: Delete file: param1=fileID
 10: Update file owner: param1=fileID, param2=userID
 11: Update file permissions: param1=fileID, param2=flags
 11: Grant user file access: param1=fileID, param2=userID
 12: Grant user folder acccess: param1=folderID, param2=userID
 13: ... to be continued
 */
 CHECK (action > 0 and action<=12)
);


CREATE TABLE publisher_grid_contracts (
 id BLOB PRIMARY KEY NOT NULL,
 publisher BLOB NOT NULL REFERENCES publishers(public_key),
 grid TEXT NOT NULL REFERENCES grids(public_key),
 -- Signatures of this contract:
 publisher_sig TEXT NOT NULL,
 grid_sig TEXT NOT NULL,
 -- Terms:
 min_bandwidth INTEGER NOT NULL,
 start_date DATE DEFAULT CURRENT_TIMESTAMP NOT NULL,
 end_date DATE DEFAULT CURRENT_TIMESTAMP NOT NULL,
 availability INTEGER NOT NULL, -- % of time online
 ping_average INTEGER DEFAULT 0,
 -- Coin terms
 coin TEXT /* example: BTC */
);


-- Table for owner requests of its grid nodes
CREATE TABLE grid_owner_requests (
 grid BLOB PRIMARY KEY REFERENCES grids(id),
 owner_sig BLOB NOT NULL,
 action INTEGER NOT NULL,
 param1,
 param2
 /* possible actions
 1: Assign storage node: param1=nodeID, param2=gatewayID
 2: Upgrade storage node to gateway: param1=nodeID
 3: Set minimum bandwidth: param1=nodeID, param2=rate
 4: Revoke node: param1=nodeID
 5: ... to be continued
 */
);

-- Table used for publishers instructing orders to contracted grids:
CREATE TABLE publisher_requests (
 grid_sig BLOB NOT NULL,
 publisher_sig BLOB,
 action INTEGER NOT NULL,
 param1,
 param2,
 /* possible actions:
 1: Accept user: param1=userID, param2=due-time
 2: Revoke user: param1=userID
 3: Remove file: param1=fileID
 4: Remove folder: param1=folderID
 5: Set user files quota: param1=userID, param2=quota
 6: Set user storage quota: param1=userID, param2=quota
 7: Set user folders quota: param1=userID, param2=quota
 8: Set file permisions: param1=fileID, param2=flags
 9: Update file owner: param1=fileID, param2=userID
 10: Update folder owner: param1=fileID, param2=userID
 11: Register nickname: param1=userID, param2=nickname
 12: Delete nickname: param1=nickname
 13: .... to be continued
 */
 CHECK (action>=1 and action<=12)
);

-- Gateways convert reconstruct data from the storage nodes and
-- present it to the users/publishers. Multiple gateways per grid
-- are possible.
CREATE TABLE gateways (
 node PRIMARY KEY REFERENCES node(public_key),
 grid NOT NULL REFERENCES grids(id),
 priority, --larger means more priority, in case of the gateway
           --to have more than one grid associated.
 grid_sig,
 node_sig
);

CREATE TABLE grid_node_contracts (
 id BLOB PRIMARY KEY NOT NULL,
 grid REFERENCES grids(public_key),
 mode NOT NULL REFERENCES nodes(public_key),
 grid_sig,
 node_sig,
 min_storage INTEGER NOT NULL,
 min_bandwidth INTEGER NOT NULL,
 start_date DATE DEFAULT CURRENT_TIMESTAMP NOT NULL,
 working_time INTEGER, -- only the grid can modify this
 -- Coin terms
 coin TEXT(4), -- ie: BTC
 bandwidth_block_size DEFAULT 100000000,
 price_per_block DEFAULT 0
);

CREATE TABLE node_audits (
 node BLOB REFERENCES nodes(public_key),
 auditor BLOB NOT NULL REFERENCES nodes(public_key),
 signature BLOB NOT NULL, -- auditors signature
 periods INTEGER DEFAULT 1, -- number of periods this audis is applicable for
 reason INTEGER NOT NULL,
 /*
 1: Ping timeout.
 2: Incorrect signature.
 3: Incorrect audition.
 4: Too slow connection.
 5: Denial of service.
 6: Corrupt data.
 7: ... to be continued
 */
 CHECK (reason>=1 and reason <=6)
);


--------------------
-- files and folders
--------------------

-- synced between publishers/grids/users but not globally.

CREATE TABLE folders (
 id BLOB NOT NULL PRIMARY KEY,
 parent REFERENCES folders(id),
 name TEXT,
 permissions REFERENCES permissions(id)
);

CREATE TABLE files (
 hash TEXT NOT NULL PRIMARY KEY,
 name TEXT,
 mime_type TEXT,
 content BLOB,
 rate INTEGER DEFAULT 0, --bandwidth rate at what must be streamed
 folder NOT NULL REFERENCES folders(id),
 user_sig NOT NULL,
 permissions REFERENCES permissions(id)
);


CREATE TABLE permissions (
 id BLOB,
 user REFERENCES users(public_key),
 publisher REFERENCES publishers(public_key),
 -- NULL user/publisher means permissions for everyone
 read BOOLEAN,
 read_quota INTEGER,
 write BOOLEAN,
 write_quota INTEGER,
 create_new BOOLEAN,
 remove BOOLEAN,
 set_perm BOOLEAN -- Meaning someone can have permissions to set permissions in UI term
);




--------------------
-- private tables --
--------------------

-- Tables not synced. Mostly internal configuration and convenient tables.

CREATE TABLE CAs (
 public_key PRIMARY KEY NOT NULL,
 private_key NOT NULL,
 proof_of_generation,
 ssl_extra TEXT
);

CREATE TABLE config (
 var,
 val
);

-- logs --
----------

CREATE TABLE logs (
 num  INTEGER PRIMARY KEY AUTOINCREMENT,
 category TEXT,
 log TEXT,
 timestamp TEXT -- Timestamp of when the log occured
);


/*

 Every table, including deriving DAs tables, need to meet certain rules. This
 table is just a configuration table never synced. It is created at the time
 of node creation and updated when the software is updated.

 When a Dapp is addded to the node, this table is updated with the information
 of the new tables.

*/

CREATE TABLE table_rules (
 table_id INTEGER PRIMARY KEY NOT NULL, -- must be unique and assigned by the repository
 table_name TEXT NOT NULL,
 dapp INTEGER REFERENCES dapps(id),

 -- exposure of the table in the nodepool
 -- 0=private;  1=grid;  2=participants only; 3=full global (careful);
 exposure INTEGER DEFAULT 0,

 -- participants (OR checked)
 -- 1=node; 2=grid owner; 4=gateways; 8=publishers; 16=users
 paticipants INTEGER DEFAULT 0,

 -- how data is synced?
 -- 0=nosync, 1=proximity, 2=random, 3=manual, 4=owner
 sync_type INTEGER DEFAULT 0,
 nodes_to_sync INTEGER DEFAULT 16,
 proximity_nodes INTEGER DEFAULT 12,

 -- how offten to check consistency? (this is different than actually syncing)
 -- in seconds, 0=nocheck
 check_every INTEGER DEFAULT 600,



 -- check function: this is a C function that checks the consistency of the
 -- last block across the nodes affected (from exposure).
 check_function TEXT DEFAULT "bc_check",

 -- sync functions: this C functions take a table and a row from argument and try
 -- to modify the local DB if tests are passed:
 insert_function TEXT default "bc_insert",
 delete_function TEXT default "bc_delete",
 update_function TEXT default "bc_update",

 -- maximum general number of transactions per check period and participant:
 max_transactions INTEGER DEFAULT 1,
 -- if max number of transaction must be specified per participant to avoid excess
 -- of flood or DDOS attacks:
 check_flood_function TEXT DEFAULT "bc_check_flood"

);


CREATE TABLE DApps (
 id INTEGER PRIMARY KEY NOT NULL, -- the ID must be unique and assigned by the repository
 name TEXT NOT NULL,
 is_static BOOLEAN DEFAULT 0, -- compiled static or dynamic.

 -- This is the name of the library (.so or .dll) file to download. This file
 -- will contain some or all the functions in the "table_rules". This file is
 -- located in the "dapp" directory.
 dapp_library TEXT
);

-- The first DApp is Bitcloud itself:
INSERT INTO DApps VALUES (1, "Bitcloud", 1, "");

-- end
