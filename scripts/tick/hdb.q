//q tick/hdb.q -p 5012

if[not "w"=first string .z.o;system "sleep 1"];

//set HDB port to 5012
system "p 5012";

//go to HDB dir
//system "cd /home/ubuntu/advKDB/tplog/sym";
tplogdir:system "echo $TPLOG_DIR";
system raze "cd ",tplogdir,"/sym";

//load HDB
\l .