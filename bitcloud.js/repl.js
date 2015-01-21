
var bitcloud = require("./bitcloud.js");
var repl = require("repl");

console.log("INFO: 'main_node' object contains the running node");

var readline = require('readline')
  , rl,
  colors = require('colors') // npm install colors #already installed
  ,help = [ 'help        ' + 'display help message.'.grey
           , '.error       ' + 'display an example error'.grey
           , 'connect      ' + 'connect to nodes .'.grey
           , '.q[uit]      ' + 'exit console.'.grey
           ].join('\n')
  ;
 
// Auto Complete Function
function completer(line) {//add all commands to be autocompleted on tab 
  var completions = 'help .error exit quit connect .q'.split(' ')
  var hits = completions.filter(function(c) {
    if (c.indexOf(line) === 0) {
      // console.log('bang! ' + c);
      return c;
    }
  });
  return [hits && hits.length ? hits : completions, line];
};
  
  

rl = readline.createInterface(process.stdin, process.stdout, completer);

rl.setPrompt("Bitcloud>");

rl.on('line', function(cmd) {
var args = cmd.split(' -');//getting argumments
//console.info(args);//use for debugging args
cmd = args[0].trim();
args.shift();//removeing cmd frmo args
  switch(cmd) {
    case 'quit':
      rl.question('Are you sure? (y/n) ', function(answer) {
        if (answer === 'y') {
          rl.close();
        } else {
          rl.prompt();
        }
      });
      break;
    case 'connect'://we can add after the connect all or connect IP_address
    var connect_setup = [],display="",error=0;
     args.map(function(a){
         var vals = a.split(' ');
         connect_setup.push(vals);
         switch(vals[0]) {
          case 'ip':
           display+='Connecting to nodes using ip='+vals[1];
            break;
          case 'limit':
            display+=' Limiting nodes number ='+vals[1]+' nodes';
            break;
          case 'type':
            display+=' and connect type of '+vals[1];
            break;
          default://unkown argument
            error=1;//set error to true and do not proceed the connection untill correct args given
            display='Unkown argument '+vals[0]+' \n  Valid arguments are:\n';
            display+='-ip : for connect with specifi ip address \n';  
            display+='-type : using connect type : either multi or single \n';
            display+='-limit : limit number of connecting nodes : Integer ';  
          }
      });
      /* Connect code here or call to function */
        console.info(display+'\n ');
        if(!error)//there is no error
          connect_setup;//use this array to setup the connection with all arguments you want
        //else 
          //log errors
      break;
    case 'help':
      var text='Bitcloud Help!\n Use the following commands for : ';//there is no problem using ' for a full string
      text += "\n help : Displays this help menu \n connect : Connects all nodes \n quit : Exits the bitcloud shell";
      console.log(text);
      break;
    default:
          console.log('Command not found :', cmd.trim() );
    console.log('Type "quit" to exit or help to display help menu ');
      break;
  }

  rl.prompt();0;
  return false;
});

rl.on('close', function() {
  console.log('All Nodes Connections closed...\n Bye');
  process.exit();
});

rl.prompt();

