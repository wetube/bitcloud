// THIS SHOULD GO TO test.js
console.log("Bitcloud.js 0.1 PoC");

var bitcloud = require('./bitcloud');
var repl = require("repl");

var nodes = [];

var main_node = bitcloud.create_node ("nodepool.db");
main_node.run();

// nodes.push(main_node);  // not sure if this works. trying to use nodes[]

//main_node.close();  // only after receiving an exit command from local_repl

/* repl.start({
  prompt: "bitcloud> ",
  input: process.stdin,
  output: process.stdout
});
*/

console.log("INFO: 'main_node' object contains the running node");
var local_repl = repl.start({ prompt : "bitcloud> ", });

local_repl.context.main_node = main_node;