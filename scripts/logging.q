
//write log funcs that create or write to logfile
//logdir:"/home/ubuntu/advKDB/log";
logdir:system "echo $LOG_DIR";
.log.procList:(5010;5011;5013;5015;5014)!`tickerPlant`RDB1`RDB2`FeedHandler`CEP;
filename:(string .log.procList[system"p"]),"_",(.Q.s1 .z.D),".log";

//if file doesnt exit, create it
if[not (`$filename) in key (hsym `$logdir); (hsym `$ raze logdir,"/",filename) 0: enlist ("Starting logfile for ",(string .log.procList[system"p"])," at time: ", string .z.P)];

//hopen handle to file
//.hdl.log:hopen hsym `$("/home/ubuntu/advKDB/log","/",filename);
.hdl.log:hopen hsym `$( raze logdir,"/",filename);

//functions that write to logfile
.log.out:{[msg] (neg .hdl.log)("INFO  ",(string .z.P),"  ",msg)};
.log.err:{[msg] (neg .hdl.log)("ERROR  ",(string .z.P),"  ",msg)};

// logged information
// details: time, user, PID, port, handle 
// .z.P, .z.u, .z.i,"system \"p\"", x, 
// types "psiii"
//.log.conn:flip `timestampOpen`timestampClosed`user`PID`port`handle`status!"PPSIIIS"$\:();

//details of conenction opened
//modify .z.po for function run on port open
.z.po:{[x] 
    .log.out["Connection opened: "];
    .log.out[("time: ",(string x".z.P"),"| user: ", (string x".z.u"), "| PID: ", (string x".z.i"), "| port: ", (string x"system \"p\""),"| handle: ",string x)];
    .log.out["Memory usage of connecting process: "];
    .log.out["; " sv (string each key .Q.w[]),'":",'(string each value .Q.w[])];
    .log.out["latest 2 "];
    };

//info of connection closed 
//modify .z.pc for function run on port close
//if this runs in TP, maintian the TP .z.pc func
.z.pc:{[x] 
        .u.del[;x]each .u.t;
        .log.out["Connection closed: "];
        .log.out[("time: ",(string .z.P),"| handle: ",string x)];
    };

//logging must include username of calling process + memory usage where applicable from .Q.w
//"; " sv (string each key .Q.w[]),'":",'(string each value .Q.w[])


