
CREATE TABLE nodes (
 CA TEXT PRIMARY KEY NOT NULL,
 address TEXT COLLATE NOCASE,
 grid TEXT COLLATE NOCASE,
 last_online DATE NOT NULL,
 storage_reputation INTEGER NOT NULL DEFAULT 0,
 bandwidth_reputation INTEGER NOT NULL DEFAULT 0
);

-- A grid is a collection of nodes associated that can sell
-- space and bandwidth to a publisher
CREATE TABLE grids (
 CA TEXT PRIMARY KEY NOT NULL,
 storage_capacity INTEGER DEFAULT 0,
 bandwidth_capacity INTEGER DEFAULT 0,
 storage_reputation INTEGER DEFAULT 0,
 bandwidth_reputation INTEGER DEFAULT 0
);

CREATE TABLE publishers (
 CA TEXT PRIMARY KEY NOT NULL,
 address TEXT COLLATE NOCASE,
 nickname TEXT,
 -- is information about the content of this publisher public?:
 public_metadata BOOLEAN DEFAULT FALSE,
 public_content BOOLEAN DEFAULT FALSE
);

CREATE TABLE publisher_trusts (
 CA NOT NULL REFERENCES publishers(CA),
 relation NOT NULL REFERENCES publishers(CA),
 trust BOOLEAN NOT NULL,
 signature NOT NULL
);


CREATE TABLE folders (
 uuid NOT NULL PRIMARY KEY, -- randomly generated
 upfolder REFERENCES folders(uuid),
 name TEXT
);

CREATE TABLE users (
 public_key TEXT PRIMARY KEY NOT NULL,
 registrant TEXT NOT NULL REFERENCES publishers(CA),
 registrant_signature,
 address TEXT COLLATE NOCASE,
 -- users can have a root folder that must sign:
 rootfolder REFERENCES folders(uuid),
 root_folder_sig
 storage_quota INTEGER DEFAULT 0,
 bandwidth_quota INTEGER DEFAULT 0,
 folder_quota INTEGER DEFAULT 0
);

CREATE TABLE publisher_grid_contracts (
 publisher TEXT NOT NULL REFERENCES publishers(CA), 
 grid TEXT NOT NULL REFERENCES grids(CA),
 -- Signatures of this contract:
 publisher_sig TEXT NOT NULL,
 grid_sig TEXT NOT NULL,
 -- Terms:
 min_storage INTEGER NOT NULL,
 min_bandwidth INTEGER NOT NULL,
 start_date DATE NOT NULL,
 end_date DATE NOT NULL,
 availability INTEGER NOT NULL, -- % of time online
 ping_average INTEGER DEFAULT 0
);

CREATE TABLE grid_node_contrats ();

CREATE TABLE auditions ();


CREATE TABLE contents (
 hash TEXT NOT NULL PRIMARY KEY,
 type_id INTEGER REFERENCES conten_types(id),
 len INTEGER,
 user TEXT NOT NULL REFERENCES users(public_key),
 signature TEXT NOT NULL
);

CREATE TABLE content_types (
 id INTEGER PRIMARY KEY,
 mime TEXT,
 encoding TEXT
);

---------------------
-- private tables

-- Notation: all private tables start with 'p'

CREATE TABLE pCAs (
 public_key PRIMARY KEY NOT NULL,
 private_key NOT NULL,
);
