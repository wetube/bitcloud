
PRAGMA foreign_keys = ON;

-- general nodepool --
-- Nodepool Team --
----------------------

-- The contents of the general nodepool are synced
-- across all the nodes in the Bitcloud.


/*

 nodes table: it is updated every time a new node registers. In order
 to register, the node do a very complex computation (like Bitcoin mining)
 in order to be accepted.

 The node must sign the entire row (except the signature itself) with its
 own public key.

 The node must provide a new signature of its row every 3 days maximum. Otherwise
 it is deleted from the nodepool and connections refused.

*/

CREATE TABLE nodes (
 id BLOB(20) PRIMARY KEY NOT NULL, -- kademlia ID
 public_key BLOB(32) NOT NULL, -- 256 bits ECDSA key
 signature BLOB(80) NOT NULL,  -- self certificate of this row
 -- Creation date must be in the current period when the node is registered.
 -- Consistance is checked by ensuring that nobody tries to register in other
 -- period that is not the actual:
 creation_date INTEGER NOT NULL,
 proof_of_creation BLOB, -- see CA generation in the protocol spec
 net_protocol INTEGER DEFAULT 1, -- 1 IP, 2 Tor
 address TEXT NOT NULL, -- IP or onion address
 storage_capacity INTEGER DEFAULT 0,  -- declared
 bandwidth_capacity INTEGER DEFAULT 0
);


/*

 node_audit table: things in this table are only inserted after a node failed
 to provide a correct check. Every single row in this table is deleted after
 every check period, and the new content based on the last one, so it can
 ensure continuation of the measurements and save space at the same time.

 For example, if a node fails to be available for some periods, there is no
 need that the nodes doing the check have to insert new rows, they just reuse
 the rows from the previous perirods, and sign the row. The limit is 16 rows per
 node.

 Auditors are random.

 Nodes doing everything perfect are never present in this table except when issued
 by malicious nodes. The majority of the net must be malicious in order to have
 consecuences for those nodes.

 Bitcloud do not count reputation, but just measures possible incorrections of the
 nodes. DAs on top could implement a system of reputation based on this table and
 other tables they provide.

*/

CREATE TABLE node_audits (
 id BLOB(20) PRIMARY KEY REFERENCES nodes(id),
 auditor BLOB(20) NOT NULL REFERENCES nodes(id),
 signature BLOB(80) NOT NULL, -- auditors signature
 periods INTEGER DEFAULT 1, -- number of periods this audis is applicable for
 reason INTEGER REFERENCES reasons(id)
);


CREATE TABLE reasons ( -- inmutable table
 id INTEGER PRIMARY KEY,
 description TEXT,
 CHECK (id > 0 and id<=6)
);

INSERT INTO reasons values (1, "Ping timeout.");
INSERT INTO reasons values (2, "Incorrect signature.");
INSERT INTO reasons values (3, "Incorrect audition.");
INSERT INTO reasons values (4, "Too slow connection.");
INSERT INTO reasons values (5, "Denial of service.");
INSERT INTO reasons values (6, "Corrupt data.");




-- A grid is a collection of nodes associated that can sell
-- space and bandwidth to a publisher
CREATE TABLE grids (
 id BLOB(20) PRIMARY KEY NOT NULL, --kademlia ID of the owner
 signature BLOB(80) NOT NULL, -- signature of the owner
 storage_capacity INTEGER DEFAULT 0,
 bandwidth_capacity INTEGER DEFAULT 0,
 storage_reputation INTEGER DEFAULT 0,
 bandwidth_reputation INTEGER DEFAULT 0,
 service_reputation INTEGER DEFAULT 0,
 availability INTEGER DEFAULT 0
);

-- Gateways convert reconstruct data from the storage nodes and
-- present it to the users/publishers. Multiple gateways per grid
-- are possible.
CREATE TABLE gateways (
 node PRIMARY KEY REFERENCES node(public_key),
 grid NOT NULL REFERENCES grids(public_key),
 priority, --larger means more priority, in case of the gateway
           --to have more than one grid associated.
 grid_sig,
 node_sig
);
CREATE TABLE coins (
 id INTEGER PRIMARY KEY,
 name TEXT NOT NULL,
 has_escrow BOOLEAN NOT NULL
);


CREATE TABLE shamir_keys (
 contract_id TEXT,
 node_id TEXT,
 part TEXT
);

-- internal publishers/grid tables --
--------------------------------

-- these tables are shared by the publishers and the grids


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

CREATE TABLE publisher_trusts (
 from_publisher NOT NULL REFERENCES publishers(public_key),
 to_publisher REFERENCES publishers(public_key),
 trust BOOLEAN NOT NULL,
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
 id BLOB(16) PRIMARY KEY NOT NULL,
 user BLOB NOT NULL REFERENCES users(public_key),
 signature BLOB NOT NULL,
 grid TEXT NOT NULL REFERENCES grids(public_key),
 action INTEGER REFERENCES user_actions(id),
 -- every type of action will have a different param values
 param1,
 param2
);

-- define some constants, this table is inmutable for bitcloud
-- but can be expanded by DAs.
CREATE TABLE user_actions (
 id INTEGER PRIMARY KEY NOT NULL,
 description TEXT,
 CHECK (id > 0 and id<=13)
);

INSERT INTO user_actions VALUES (1, 'Download file');
-- bandwidth rate is not important
-- param1: file id; param2: offset

INSERT INTO user_actions VALUES (2, 'Stream file');
-- bandwidth rate is important
-- param1: file id; param2: offset

INSERT INTO user_actions VALUES (3, 'Upload file');
-- param1: file id; param2: folder id;

INSERT INTO user_actions VALUES (4, 'Create folder');
-- param1: folder id;

INSERT INTO user_actions VALUES (5, 'Remove folder');
-- param1: folder id;

INSERT INTO user_actions VALUES (6, 'Rename folder');
-- param1: folder id; param2: new name;

INSERT INTO user_actions VALUES (7, 'Move file');
-- param1: origin folder id; param2: final folder id;

INSERT INTO user_actions VALUES (8, 'Rename file');
-- param1: file id; param2: new name;

INSERT INTO user_actions VALUES (9, 'Delete file');
-- param1: file id;

INSERT INTO user_actions VALUES (10, 'User permisions');
-- param1: user public_key; param2: boolean grant or deny

INSERT INTO user_actions VALUES (11, 'Folder permissions');
-- param1: user public_key; param2: boolean grant or deny

INSERT INTO user_actions VALUES (12, 'Set user quota');
-- param1: user public_key; param2: amount

 
CREATE TABLE publisher_grid_contracts (
 id BLOB(16) PRIMARY KEY NOT NULL,
 publisher BLOB NOT NULL REFERENCES publishers(public_key), 
 grid TEXT NOT NULL REFERENCES grids(public_key),
 -- Signatures of this contract:
 publisher_sig TEXT NOT NULL,
 grid_sig TEXT NOT NULL,
 -- Terms:
 min_storage INTEGER NOT NULL,
 min_bandwidth INTEGER NOT NULL,
 start_date DATE DEFAULT CURRENT_TIMESTAMP NOT NULL,
 end_date DATE DEFAULT CURRENT_TIMESTAMP NOT NULL,
 availability INTEGER NOT NULL, -- % of time online
 ping_average INTEGER DEFAULT 0,
 -- Coin terms
 coin REFERENCES coins(id)
);

CREATE TABLE auditions (
 id BLOB PRIMARY KEY NOT NULL,
 user_sig BLOB,
 publisher_sig BLOB,
 grid_sig BLOB,
 bandwidth INTEGER,
 time REAL,
 ok BOOLEAN
);

CREATE TABLE folders (
 id BLOB(16) NOT NULL PRIMARY KEY,
 parent REFERENCES folders(id),
 name TEXT,
 permissions REFERENCES permissions(id)
);

CREATE TABLE files (
 hash TEXT NOT NULL PRIMARY KEY,
 name TEXT,
 type_id INTEGER REFERENCES content_types(id),
 content BLOB,
 rate INTEGER DEFAULT 0, --bandwidth rate at what must be streamed
 folder NOT NULL REFERENCES folders(id),
 user_sig NOT NULL,
 permissions REFERENCES permissions(id)
);

CREATE TABLE content_types (
 id INTEGER PRIMARY KEY,
 mime TEXT,
 encoding TEXT
);

CREATE TABLE permissions (
 id BLOB(16),
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
 

-- internal grid tables --
--------------------------


CREATE TABLE grid_node_contrats (
 id BLOB(16) PRIMARY KEY NOT NULL,
 grid REFERENCES grids(public_key),
 mode NOT NULL REFERENCES nodes(public_key),
 grid_sig,
 node_sig,
 min_storage INTEGER NOT NULL,
 min_bandwidth INTEGER NOT NULL,
 start_date DATE DEFAULT CURRENT_TIMESTAMP NOT NULL,
 working_time INTEGER, -- only the grid can modify this
 -- Coin terms
 coin REFERENCES coins(id),
 bandwidth_block_size DEFAULT 100000000,  
 price_per_block DEFAULT 0
);



-- private tables --
--------------------

CREATE TABLE CAs (
 public_key PRIMARY KEY NOT NULL,
 private_key NOT NULL,
 proof_of_generation,
 ssl_extra TEXT
);

CREATE TABLE config (
 var
 val
);

-- logs --
----------

CREATE TABLE logs (
 num  INTEGER PRIMARY KEY AUTOINCREMENT,
 category TEXT,
 log TEXT
 timestamp TEXT -- Timestamp of when the log occured
);
