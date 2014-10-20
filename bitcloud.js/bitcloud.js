// Copyright Bitcloud Foundation (2014)

// testing new js version

// For local interface via Node.JS
var repl = require('repl');

// Include objects required for BC functionality <-- BC dependencies
var ub = require ("ubjson");
var sqlite3 = require ("sqlite3");
var net = require('net');
var fs = require("fs");
var crypto = require("crypto");
var rsa = require("node-rsa");


var LOGERROR = 0;
var LOGWARNING = 1;
var LOGINFO = 2;

// List of  nodes running locally:
var nodes = [];

// Returns a complete Node object

function initialize_local_node (filename, init_admin) {
    var db = new sqlite3.Database(filename, sqlite3.OPEN_READWRITE);
    var key = null;
    return {
    db          : db,
    id          : null, // the node id (extracted from the nodepool)
    connected   : false,
    connections : [],  // current connections for this period
    grids       : [], // grids in which to participate
    server      : null,
    filename    : filename,

    init_admin   : init_admin || false,
    run_admin   : require("./admin.js").run,

    running     : false,
    run         : function (port, ip) {
        var node = this;
        // TODO: obtain id and key
        this.server = net.createServer(function(sockect) {
            sockect.write (node.filename);
            sockect.pipe (sockect);
        });
        port = port || 19999;
        ip = ip || '127.0.0.1';
        this.server.listen(port, ip);
        this.log(null, LOGINFO, filename + " is running on " + ip + ":" + port);

        nodes.push(this);
        this.running = true;
        return true;
    },
    stop        : function () {
        this.server.close();
        this.running = false;
        return true;
    },
    close       : function () {
        this.stop();
        this.db.close();
    },

    log_console : true,
    log_db      : true,
    log_admin   : true, // log to admin interface if connected
    log         : function (table, log_type, text) {
        if (this.log_console)
            console.log((table ? table + ': ' : '')  + text);
    },

    // ----- SYNCING
    sync_period : 10, // global tables sync period
    sync_with   : function (other) {
        /* Sync with another node, given its id.
        As the whitepaper specify, be careful with whom you sync, it should
        be in the list of allowed (see 'get_sync_list'), or there is risk of
        being banned.*/
    },
    get_sync_list   : function () {
        // Get the list of nodes to sync with in this period
    },

    sync        : function () {
        /* General sync, this normally calls sync_with at each period for every
        needed node */
    },

    // ----- COMMANDS
    command     : function (table, ubcommand) {
        /* Process a command in UBJSON format and run the checks.
        This is very often related to command parameters in the *_requests
        tables.

            table       : table name
            ubcommand   : command as directly read from the sync function

        TODO: define ubjson command  format */

    },

    // ----- CA
    create_id   : function (country, region, city, center, array) {
        /* Creates a random proximity ID.
        TODO */
        this.id = crypto.randomBytes(20); // provisional solution
        return this.id;
    },
    mine_CA     : function (problem) {
        /* Given a problem based on a deterministic global table, mine a CA
        TODO */
        key = new rsa.NodeRSA({b: 2048});
    },
    register    : function () {
        /* Register this node in the Bitcloud
        TODO */
        if (!key) throw ("Cannot register without a CA");
    },
    quick_start : function (grid) {
        /* Do all the hard staff automatically:
        - mine a CA
        - create an ID
        - register
        - connect to the grid */
    },

    // ----- remote db management
    insert      : function (id, table, values) {
        /* Insert a record in the tables, given:
            id      : id of the soliciting node
            table   : table to insert (after verification)
            value   : array consituting the elements of the record
        Note: the signature of the operation is included in the record as stated
        in nodepool.sql*/
        db.serialize(function() {
            var stmt = db.prepare("INSERT INTO " + table + " VALUES (?,?)");
            stmt.run(values);
            stmt.finalize();
        });

    },
    delete      : function (id, table, key, signature) {
        /* Delete a record in the tables, given:
            id      : id of the soliciting
            table   : table to insert (after verification)
            key     : key to identify the record
            signature: the node certificate of this operation*/
    },
    update      : function (id, table, key, values) {
        /* Insert a record in the tables, given:
            id      : id of the soliciting node
            table   : table to insert (after verification)
            value   : array consituting the elements of the record
        Note: the signature of the operation is included in the record as stated
        in nodepool.sql*/

    },

    // ----- local db management
    sql         : function (statement, values) {
        // A wrapper for sqlite3.Database.run() with some extra checks
    }
}}



console.log("Bitcloud.js 0.1 PoC");

var main_node = initialize_local_node ("nodepool.db");
main_node.run();

nodes.push(main_node);  // not sure if this works. trying to use nodes[]

//main_node.close();

console.log("INFO: 'main_node' object contains the running node");
var local_repl = repl.start("bitcloud> ");

local_repl.context.main_node = main_node;
