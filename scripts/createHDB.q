

//   ./createHDB.q -logfile sym2021.03.24


//filename:raze ("/home/ubuntu/advKDB/tplog/"),(.Q.opt .z.X )`logfile;
tplogdir:system "echo $TPLOG_DIR";
filename:raze (tplogdir),"/",(.Q.opt .z.X )`logfile;

// get the tplog
// define schema and upd to be able to replay logfile
//rawTPLog:get hsym`$"/home/ubuntu/advKDB/tplog/sym2021.03.24";

//extract data from logfile
//load schemas
rootdir:system "echo $ROOT_HOME"
//system"l /home/ubuntu/advKDB/scripts/tick/sym.q";
system raze"l ",rootdir,"/scripts/tick/sym.q";

//define upd
upd:{[t;x] t insert x};
//replay logfile, this returns __ and executes the upd to insert data into the sym.q tables
//-11! hsym `$filename;
-11! hsym `$filename;
date:-10#filename;
//dir:hsym `$"/home/ubuntu/advKDB/tplog","/compressDB";
dir:hsym `$ raze tplogdir,"/compressDB";

//save down HDB, partitioned by date
//.Q.dpft[`:/home/ubuntu/advKDB/tplog/compressDB;value"2021.03.24";`sym;`trade]
.Q.dpft[dir;value date;`sym;`trade];
.Q.dpft[dir;value date;`sym;`quote];
.Q.dpft[dir;value date;`sym;`agrTab];


//compress HDB
system "cd ",1_string dir;
system "cd ",date;

tradeColsCompress:` sv' `:trade,/:key[`:trade] except `time`sym;
quoteColsCompress:` sv' `:quote,/:key[`:quote] except `time`sym;
agrColsCompress:` sv' `:agrTab,/:key[`:agrTab] except `time`sym;

{-19!(x;x;16;0;0)} each tradeColsCompress;
{-19!(x;x;16;0;0)} each quoteColsCompress;
{-19!(x;x;16;0;0)} each agrColsCompress;

exit 0



