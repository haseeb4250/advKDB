/2019.06.17 ensure sym has g attr for schema returned to new subscriber
/2008.09.09 .k -> .q
/2006.05.08 add


//enter .u namespace
\d .u

//.u.w dictionary of tablenames!(handle;subscribed syms)
//this line defines .u.t = tablenames, .u.w is empty subscriber list with tablenames as keys
init:{w::t!(count t::tables`.)#()}

//.u.del[table;sym] - remove subscribers from .u.w
del:{w[x]_:w[x;;0]?y};.z.pc:{del[;x]each t};

//.u.sel[x;y]
sel:{$[`~y;x;select from x where sym in y]}

//.u.pub[t;x] 
pub:{[t;x]{[t;x;w]if[count x:sel[x]w 1;(neg first w)(`upd;t;x)]}[t;x]each w t}

//.u.add
add:{$[(count w x)>i:w[x;;0]?.z.w;.[`.u.w;(x;i;1);union;y];w[x],:enlist(.z.w;y)];(x;$[99=type v:value x;sel[v]y;@[0#v;`sym;`g#]])}

//.u.sub[table;sym] - add a subscriber to u.w
sub:{if[x~`;:sub[;y]each t];if[not x in t;'x];del[x].z.w;add[x;y]}

//.u.end - save RDB contents to HDB directory at end of day
end:{(neg union/[w[;;0]])@\:(`.u.end;x)}
