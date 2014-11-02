// Copyright Bitcloud Foundation (2014)


// Include objects required for BC functionality <-- BC dependencies
//var ub = require ("ubjson");  // JSON for now
var sqlite3 = require ("sqlite3");
var net = require('net');
var fs = require("fs");
var crypto = require("crypto");
var rsa = require("node-rsa");

var LOGERROR = 0;
var LOGWARNING = 1;
var LOGINFO = 2;

// List of local Bitcloud node instances
var nodes = [];


// Returns a complete Node object
function create_node (filename, init_admin) {
    var db = new sqlite3.Database(filename, sqlite3.OPEN_READWRITE);
    var block = new sqlite3.Database(":memory:");
    var last_block = new sqlite3.Database(":memory:");
    var key = null;
    var sig = null;
    return {
    block       : block, // current block being synced in real time
    last_block  : last_block, // last block to be hashed, signed and checked
    id          : null, // the node id (extracted from the nodepool)
    grids       : [], // grids in which to participate
    filename    : filename,

    init_admin   : init_admin || false,
//    run_admin   : require("./admin.js").run,  // not needed right now

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
    //-------------------------------------
    // ----- COMMUNICATION
    // - For networking and JSON messaging
    // - First declaration of communication elements
    // -----------------
    connections : [],  // current connections for this period
    server      : null,
    connected   : false,
    // -----------------
    // - communication functions
    // -----------------
    open_listen     : function () {
        /*  Opens a listening port to receive external connections */    
        
    },
        
    receive_connect : function () {
        /*  Handle and process an incoming connection.  Either the incoming 
            connection is a synch request, an external request (like Publisher, 
            user, or even another grid/node), audit or other administration 
            request, or someone trying to attack the node. Any other cnnection
            types? Returns connection object. */
    },
    
    connect_node    : function(node_id, connect_type) {
        /*  Connect to another node or external entity. connect_type likely 
            will be a multi-element object. May be used by sync functions 
            below.  Returns connection object.  */
        
    },

    connect_ip      : function(ip, connect_type) {
        /*  Connect to another node or external entity. connect_type likely 
            will be a multi-element object. May be used by sync functions 
            below.  Returns connection object.  */
        
    },

    
    close_connect   : function(connection) {
        /*  Close a connection.  Returns success/error code. 
            Possibly also with an "all" input option to close out all.
            Include connection garbage collection in this function. */
        
    },
    
    msg_pack    : function(type, data) {
        /*  Packing data/instructions into something transmittable. Returns 
            packed message. */
    },
    
    msg_transmit    : function(message, connection) {
        /*  Send a message to a particule connection.  Returns success code. */
    },
    
    msg_receive     : function(message) {
        /*  Process an incoming message for unpacking. - validate compatible 
            packing protocol (e.g., UBJSON, JSON, etc.) was used - validate 
            that the message has no errors (e.g., checksum) */  
    },
    
    msg_unpack      : function(message) {
        /*  Unpack the message.  Returns list containing command type and any 
            attached data.  Commands may be queries, synch RPCs, transmission 
            of data slice, or other. */
    },
    
    //-------------------------------------
    // ----- SYNCHING
    // - For all synchronization elements and functions
    // -----------------
    // - First declaration of synchronization elements    
    // -----------------
    sync_period     : 10, // global tables sync period

    // -----------------
    // - synchronization functions
    // -----------------
    sync_with       : function (other) {
        /* Sync with another node, given its id.
        As the whitepaper specify, be careful with whom you sync, it should
        be in the list of allowed (see 'get_sync_list'), or there is risk of
        being banned.*/
    },
    get_sync_list   : function () {
        // Get the list of nodes to sync with in this period
    },

    sync            : function () {
        /* General sync, this normally calls sync_with at each period for every
        needed node */
    },

    // ----- COMMANDS
    command_parse   : function(command_list) {
        /* uses output of msg_unpack to process command.  May call qry_command
        function below, if applicable to a DB query. */
    },
    
    
    qry_command         : function (table, command) {
        /* Process a DB command and run the checks.
        This is very often related to command parameters in the *_requests
        tables.

            table       : table name
            command   : DB command as directly read from the sync function */

    },
    
    //-------------------------------------
    // ----- CA
    create_id   : function (country, region, city, center, array) {     
        // temp comment: why country, region, city, etc.?  is this really needed?  Especially in the PoC?
        // also, what is "center" and "array"?
        
        /* Creates a random proximity ID.
        TODO */
        this.id = crypto.randomBytes(20); // provisional solution
        return this.id;
    },
    mine_CA     : function (problem) {
        /* Given a problem based on a deterministic global table, mine a CA
            problem     : string that must be salted with previous hash then hashed using CA
        */
        key = new rsa.NodeRSA({b: 2048});
        sig = key.sign(problem, 'base64');
    },
    store_CA    : function(CA_key, CA_sig){
        /* Save the mined CA in applicable private table */
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
    //-------------------------------------
    // ----- DB operations code
    // -----------------
    // - DB elements
    // -----------------
    db          : db, // nodepool db
    // TODO: define the node object type, for working with various nodes at a time

    // -----------------
    // - DB functions
    // -----------------    
    
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

    },
    
    get_node    : function (node_id) {
        // returns a node object for the node "node_id"
    },
    
    push_node   : function (node_obj) {
        /*  takes a node object and serializes it into a record and adds the 
            record to nodes table */
    },
    
    update_node : function (node_obj) {
        /*  updates the record for node_obj.node_id with all the current values
            contained in node_obj */
    }
}}


function create_grid (name, owner) {
return { // todo
    id      : null
}}

function create_publisher (name){
return { // todo
    id      : null
}}


// EXPORTS
exports.create_node = create_node;
exports.create_grid = create_grid;
exports.create_publisher = create_publisher;

exports.LOGERROR =      LOGERROR;
exports.LOGWARNING =    LOGWARNING;
exports.LOGINFO =       LOGINFO;

// TODO: command line options

