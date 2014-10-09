// testing new js version

var repl = require('repl');

var ub = require ("ubjson");
var sqlite3 = require ("sqlite3");
var net = require('net');
var fs = require("fs");


var LOGERROR = 0;
var LOGWARNING = 1;
var LOGINFO = 2;

// List of running nodes:
var nodes = [];

function make_node (filename, init_admin) {
    var db = new sqlite3.Database(filename, sqlite3.OPEN_READWRITE);
    return {
    db          : db,
    id          : null, // the node id (extracted from the nodepool)
    connected   : false,
    server      : null,
    filename    : filename,

    init_admin   : init_admin || false,
    run_admin   : require("./admin.js").run,

    running     : false,
    run         : function (port, ip) {
        var node = this;

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
    }
}}



console.log("Bitcloud.js 0.1 PoC");

var main_node = make_node ("nodepool.db");
main_node.run();

//main_node.close();

console.log("INFO: 'main_node' object contains the running node");
var local_repl = repl.start("bitcloud> ");

local_repl.context.main_node = main_node;
