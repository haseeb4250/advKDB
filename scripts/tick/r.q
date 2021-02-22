/q tick/r.q [host]:port[:usr:pwd] [host]:port[:usr:pwd]
/2008.09.09 .k ->.q

//if not windows, sleep for 1 second before trying to connect to other procs
if[not "w"=first string .z.o;system "sleep 1"];

//upd function for RDB
upd:insert;

/ get the TP and HDB ports from .z.x, defaults are 5010,5012
.u.x:.z.x,(count .z.x)_(":5010";":5012");

// end of day: save, clear, hdb reload
// .Q.hdpf[`:localhost:5002;`:.;2014.08.23;sym]
// .Q.hdpf[HDB; pwd (root of partitioned db); date partition to write; column to sort on]
.u.end:{
    t:tables`.;
    t@:where `g=attr each t@\:`sym;
    .Q.hdpf[`$":",.u.x 1;`:.;x;`sym];
    @[;`sym;`g#] each t;
    };

// init schema and sync up from log file;cd to hdb(so client save can run)
// .u.rep arguments provided by TP upon subscription
// x is 2-item list of lists of tablename + empty schema
// y is 2-item list of (number of msgs written to logfile; logfile filepath)
.u.rep:{
    //initialize (set each tablename to its empty schema)
    (.[;();:;].)each x;
    //if nothing was written tplog, exit
    if[null first y;:()];
    //replay logfile, this will populate the tables in RDB
    -11!y;
    //cd to the root dir of partition db
    system "cd ",1_-10_string first reverse y
    };
/ HARDCODE \cd if other than logdir/db

// connect to ticker plant for (schema;(logcount;log))
// open handle to TP, subscribe to all tables (will need to modify for RDB1 = quote,trade RDB2= agrTab); get second argument y (length of TP logfile, location) 
.u.rep .(hopen `$":",.u.x 0)"(.u.sub[`;`];`.u `i`L)";

