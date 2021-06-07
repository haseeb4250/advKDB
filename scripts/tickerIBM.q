
//Usage: 
// q tickerIBM.q -file sym2021.03.09

filename:(.Q.opt .z.X)`file;
tplogdir:system "echo $TPLOG_DIR";

//read in tp log
//data:get hsym `$"/home/ubuntu/advKDB/tplog/sym2021.03.09";
//data:get hsym `$ raze "/home/ubuntu/advKDB/tplog/",filename;
data:get hsym `$ raze tplogdir,"/",filename;

//filter for trade table
i: til count data;
data:data where {[x] `trade in data[x][1]} each i;

//filter for IBM in ticker
data:data where {[x] `IBM in data[x][2]} each i;

//save IBM data under a new filename
//(hsym `$"/home/ubuntu/advKDB/tplog/", raze filename,"IBM") set data;
(hsym `$ raze tplogdir, "/",filename,"IBM") set data;

exit 0
