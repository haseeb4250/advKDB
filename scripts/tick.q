
/ q tick.q sym . -p 5001 </dev/null >foo 2>&1 &
/2014.03.12 remove license check
/2013.09.05 warn on corrupt log
/2013.08.14 allow <endofday> when -u is set
/2012.11.09 use timestamp type rather than time. -19h/"t"/.z.Z -> -16h/"n"/.z.P
/2011.02.10 i->i,j to avoid duplicate data if subscription whilst data in buffer
/2009.07.30 ts day (and "d"$a instead of floor a)
/2008.09.09 .k -> .q, 2.4
/2008.02.03 tick/r.k allow no log
/2007.09.03 check one day flip
/2006.10.18 check type?
/2006.07.24 pub then log
/2006.02.09 fix(2005.11.28) .z.ts end-of-day
/2006.01.05 @[;`sym;`g#] in tick.k load
/2005.12.21 tick/r.k reset `g#sym
/2005.12.11 feed can send .u.endofday
/2005.11.28 zero-end-of-day
/2005.10.28 allow`time on incoming
/2005.10.10 zero latency
"kdb+tick 2.8 2014.03.12"

//q tick.q SRC [DST] [-p 5010] [-o h]
//q tick.q tick/sym.q $TPLOG_DIR -p $TICK_PORT -t 1000
//         -symdir  -TPlogdir  -port  -tick interval
// tplogdir = /home/ubuntu/advKDB/tplog
// symdir = /home/ubuntu/advKDB/tick
// src = ("/home/ubuntu/advKDB/tick";"/home/ubuntu/advKDB/tplog")
//loading in the sym file

//load in the sym.q file with table schemas
//system"l tick/",(src:first .z.x,enlist"sym"),".q"
//system"l scripts/tick/sym.q"
//system"l ",src:first .z.x;
system"l ./tick/",(src:first .z.x),".q";


// with first argument tick/
//system"l tick/",(src:first .z.x,enlist"sym"),".q"

//check src
.debug.src:src;

//set port if not set
if[not system"p";system"p 5010"]

//load in u.q file"
\l tick/u.q

//define .u functions
\d .u

//.u.ld[date] - check the tp logdir for existence of logfile for date, if does not exist will create it to .u.L path
ld:{
    //redefine .u.L depending on date
    if[not type key L::`$(-10_string L),string x;
        .[L;();:;()]];
    //define .u.i and .u.j; -11(-2;tplog) returns the length of log 
    i::j::-11!(-2;L);    
    //check if log was corrupt
    if[0<=type i;
        -2 (string L)," is a corrupt log. Truncate to length ",(string last i)," and restart";
        exit 1];
    //return handle to tplog back to .u.l
    hopen L
    };

//.u.tick - run .u.init defning .u.w and .u.t; check if time, sym columns exist for all tables;apply group attribute to sym col; set .u.d to today;  
tick:{
    //init defines .u.t, create empty subscriber list .u.w
    init[];
    //error if time and sym are not the first 2 columns in any table
    if[not min(`time`sym~2#key flip value@)each t;'`timesym];
    //apply grouped attribute on sym for each table
    @[;`sym;`g#]each t;
    //define .u.d = today
    d::.z.D;
    //if tplogdir (y) passed in; define .u.L temp; call .u.ld on today's date
    if[l::count y;L::`$":",y,"/",x,10#".";l::ld d]
    };

//.u.endofday: calls .u.end on .u.d and increments .u.d; redefines .u.l on new day by calling .u.ld
endofday:{
    end d;
    d+:1;
    if[l;hclose l;l::0(`.u.ld;d)]
    };

//.u.ts[date] - calls .u.endofday when day rolls over, runs on timer in .z.ts to continually check
ts:{if[d<x;if[d<x-1;system"t 0";'"more than one day?"];endofday[]]};

//if timer /t is set;run .u.pub on timer for each table; run .u.ts on timer .z.ts with today's date; define.u.upd
if[system"t";
 .z.ts:{pub'[t;value each t];@[`.;t;@[;`sym;`g#]0#];i::j;ts .z.D};
 upd:{[t;x]
 if[not -16=type first first x;if[d<"d"$a:.z.P;.z.ts[]];a:"n"$a;x:$[0>type first x;a,x;(enlist(count first x)#a),x]];
 t insert x;if[l;l enlist (`upd;t;x);j+:1];}];

//if timer /t is not set, set it to 1000ms; run .u.ts on timer with today's date; define .u.upd
if[not system"t";system"t 1000";
 .z.ts:{ts .z.D};
 upd:{[t;x]ts"d"$a:.z.P;
 if[not -16=type first first x;a:"n"$a;x:$[0>type first x;a,x;(enlist(count first x)#a),x]];
 f:key flip value t;pub[t;$[0>type first x;enlist f!x;flip f!x]];if[l;l enlist (`upd;t;x);i+:1];}];

\d .

.u.tick[src;.z.x 1];

\
 globals used
 .u.w - dictionary of tables->(handle;syms)
 .u.i - msg count in log file
 .u.j - total msg count (log file plus those held in buffer)
 .u.t - table names
 .u.L - tp log filename, e.g. `:./sym2008.09.11
 .u.l - handle to tp log file
 .u.d - date

/test
>q tick.q
>q tick/ssl.q

/run
>q tick.q sym  .  -p 5010	/tick
>q tick/r.q :5010 -p 5011	/rdb
>q sym            -p 5012	/hdb
>q tick/ssl.q sym :5010		/feed

