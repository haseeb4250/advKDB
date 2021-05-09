

//   ./createHDB.q -logfile sym2021.03.24


filename:raze ("/home/ubuntu/advKDB/tplog/"),(.Q.opt .z.X )`logfile;

// get the tplog
// define schema and upd to be able to replay logfile
//rawTPLog:get hsym`$"/home/ubuntu/advKDB/tplog/sym2021.03.24";

//extract data from logfile
//load schemas
system"l /home/ubuntu/advKDB/scripts/tick/sym.q";
//define upd
upd:{[t;x] t insert x};
//replay logfile, this returns __ and executes the upd to insert data into the sym.q tables
//-11! hsym `$filename;
-11! hsym `$filename;
date:-10#filename;
dir:hsym `$"/home/ubuntu/advKDB/tplog","/compressDB";

//save down HDB, partitioned by date
//.Q.dpft[`:/home/ubuntu/advKDB/tplog/compressDB;value"2021.03.24";`sym;`trade]
.Q.dpft[dir;value date;`sym;`trade];
.Q.dpft[dir;value date;`sym;`quote];
.Q.dpft[dir;value date;`sym;`agrTab];


//compress HDB



