
//connect to TP
//replace with command line argument for port
h:neg hopen `:localhost:5010;

//load in logging script
system"l logging.q";

//load table schemas
\l tick/sym.q
//define stocks and starting prices
syms:`MSFT`IBM`GS`AAPL`TSLA`CCL;
prices:syms!100.05 200.10 352.11 20.00 40.00 55.50;

//number of rows per update
n:1;

//randomize price movement 
getmovement:{[s] rand[0.0001]*prices[s]};

//generate trade price, bid and ask

getprice:{[s] prices[s]+:rand[1 -1]*getmovement[s]; prices[s]};
getbid:{[s] prices[s]-getmovement[s]};
getask:{[s] prices[s]+getmovement[s]};

/Timer to control data generation
.z.ts:{
    //update for n random syms per interval
    s:n?syms;
    //send trade and quote to TP
    h(`.u.upd;`trade;(n#.z.N;s;getprice'[s];n?1000));
    h(`.u.upd;`quote;(n#.z.N;s;n?1000;n?1000;getbid'[s];getask'[s]))
    };

/trigger timer every 1s
\t 1000


