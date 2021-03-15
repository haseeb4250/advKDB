
//q loadCSV.q -path /home/ubuntu/advKDB/csv/quote1.csv 

//get TP port
portTP:5010i;

//load in existing schemas 
system "l tick/sym.q"

//get CSV path
fp:(.Q.opt .z.X)`path;
fp:"/home/ubuntu/advKDB/csv/quote1.csv";
headerCols:`$'"," vs first read0 hsym `$fp;
schemaCols:(exec c from meta quote);

//read csv into correct table/schema
selectTab:first  (tables[]) where {headerCols~x} each  ({[x] exec c from meta x} each tables[]);
//if selectTab is null, exit
if[null selectTab; exit 0];
//1_flip  (upper exec t from meta selectTab;",") 0: hsym `$fp
data:1_'(upper exec t from meta selectTab;",") 0: hsym `$fp



//hopen to TP and publish (same way CEP did it)
h:hopen `::5010;
h(`.u.upd;`quote;data);


