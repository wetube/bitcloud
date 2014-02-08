
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
 address TEXT COLLATE NOCASE
);

CREATE TABLE users (
 public_key TEXT PRIMARY KEY NOT NULL,
 registrant TEXT NOT NULL REFERENCES publishers(CA),
 address TEXT COLLATE NOCASE
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


