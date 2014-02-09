-- general nodepool --
----------------------

-- The contents of the general nodepool are synced
-- across all the nodes in the Bitcloud.

CREATE TABLE nodes (
 public_key PRIMARY KEY NOT NULL,
 signature,  -- self certificate of the public key
 creation_date DATE
 proof_of_creation, -- see CA generation in the protocol spec
 address TEXT COLLATE NOCASE,
 main_grid REFERENCES grids(public_key) COLLATE NOCASE,
 last_online DATE,
 storage_capacity INTEGER DEFAULT 0,
 bandwidth_capacity INTEGER DEFAULT 0,
 storage_reputation INTEGER DEFAULT 0,
 bandwidth_reputation INTEGER DEFAULT 0,
 service_reputation INTEGER DEFAULT 0,
 in_grid_reputation INTEGER DEFAULT 0,
 availability INTEGER DEFAULT 0
);

-- A grid is a collection of nodes associated that can sell
-- space and bandwidth to a publisher
CREATE TABLE grids (
 public_key PRIMARY KEY NOT NULL,
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
 node REFERENCES node(public_key),
 grid NOT NULL REFERENCES grids(public_key),
 priority, --larger means more priority, in case of the gateway
           --to have more than one grid associated.
 grid_sig,
 node_sig
);


CREATE TABLE publishers (
 public_key PRIMARY KEY NOT NULL,
 address TEXT COLLATE NOCASE,
 creation_date DATE NOT NULL,
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
 to_publisher NOT NULL REFERENCES publishers(public_key),
 trust BOOLEAN NOT NULL,
 signature NOT NULL, -- from signature
 reason REFERENCES reason(id) NOT NULL
);

CREATE TABLE reasons (
 id,
 description
);


CREATE TABLE users (
 public_key PRIMARY KEY NOT NULL,
 publisher NOT NULL REFERENCES publishers(public_key),
 publisher_signature,
 address TEXT COLLATE NOCASE,
 fixed_address BOOLEAN DEFAULT TRUE,
 revocation_date DATE,
 storage_quota INTEGER DEFAULT 0,
 bandwidth_quota INTEGER DEFAULT 0,
 files_quota INTEGER DEFAULT 0, -- how many files can upload
 folder_quota INTEGER DEFAULT 0, -- how many folders allowed
 root_folder REFERENCES folders(id)
);

CREATE TABLE publisher_grid_contracts (
 id BLOB(16) PRIMARY KEY NOT NULL,
 publisher TEXT NOT NULL REFERENCES publishers(public_key), 
 grid TEXT NOT NULL REFERENCES grids(public_key),
 -- Signatures of this contract:
 publisher_sig TEXT NOT NULL,
 grid_sig TEXT NOT NULL,
 -- Terms:
 min_storage INTEGER NOT NULL,
 min_bandwidth INTEGER NOT NULL,
 start_date DATE NOT NULL,
 end_date DATE NOT NULL,
 availability INTEGER NOT NULL, -- % of time online
 ping_average INTEGER DEFAULT 0,
 -- Coin terms
 coin REFERENCES coins(id),
);


CREATE TABLE coins {
 id INTEGER PRIMARY KEY,
 name TEXT NOT NULL,
 has_escrow BOOLEAN NOT NULL
);

CREATE TABLE accepted_coins (
);

CREATE TABLE shamir_keys (
 contract_id TEXT,
 node_id TEXT,
 part TEXT
);

CREATE TABLE auditions ();


-- internal grid tables --
--------------------------


CREATE TABLE folders (
 id BLOB(16) NOT NULL PRIMARY KEY, 
 name TEXT,
);

CREATE TABLE files (
 hash TEXT NOT NULL PRIMARY KEY,
 type_id INTEGER REFERENCES conten_types(id),
 content BLOB,
 folder NOT NULL REFERENCES folders(id),
 user_sig NOT NULL,
 publisher_sig  -- NULL for the public grid
);

CREATE TABLE content_types (
 id INTEGER PRIMARY KEY,
 mime TEXT,
 encoding TEXT
);

CREATE TABLE grid_node_contrats (
 id BLOB(16) PRIMARY KEY NOT NULL,
 grid REFERENCES grids(public_key),
 mode NOT NULL REFERENCES nodes(public_key),
 grid_sig,
 node_sig,
 min_storage INTEGER NOT NULL,
 min_bandwidth INTEGER NOT NULL,
 start_date DATE NOT NULL,
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

