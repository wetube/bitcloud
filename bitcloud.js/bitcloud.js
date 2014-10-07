// testing new js version

ub = require ("ubjson");
sqlite3 = require ("sqlite3");

var nodes = [];

function new_node (filename) {
    var db = new sqlite3.Database (filename);
    node = {
        filename    : filename,
        db          : db,
        running     : false,
        socket      : null,
        run         : function () {
            //todo
            this.running = true;
            return true;
        },
        stop        : function () {
            this.running = false;
            return true;
        }
    };
    nodes.push (node);
    return node;
}

main_node = new_node("main_nodepool.db");
main_node.run();
console.log (main_node.running);
