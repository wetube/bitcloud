
var bitcloud = require("./bitcloud.js");
var repl = require("repl");

console.log("INFO: 'main_node' object contains the running node");
var local_repl = repl.start("bitcloud> ");

//local_repl.context.main_node = main_node;

// TODO: command line options

/*  Here We'll list all of REPL deafault and custom Commands

.exit : for existing

*/

// .exit already exists in REPL

local_repl.on('exit', function () {
  console.log('Got "exit" event from repl!');
  process.exit();

});

// define new commands here

local_repl.context.list = function () {//all of this are just tests don't remove them please
  console.log('Got "list" event from repl!');
  process.stdin.emit('_.length')
};

replQuit = function () {//all of this are just tests don't remove them please
  console.log('Got "quit" event from repl!');
  process.exit();
};

local_repl.context.quit = replQuit;



function list1 () {
  console.log('Got "list" event from repl!');
}

 var system = require('system');

if (system.args.length === 1) {
  console.log('Usage: loadspeed.js <some URL>');
  console.log(system.args[1]);
}



process.stdin.setEncoding('utf8');    // this is where the input is processed?


/*
var util = require('util');

process.stdin.on('data', function (text) {
    console.log('received data:', util.inspect(text));
    if (text === 'list\n') {
      console.log('you wrote "list" ');
      list1();
    }
}); 
*/