set
i areas /v1*v9/;

alias(i,j);
alias(i,k);


*High values for t(i,j) for the non-existing links so that they won't be chosen
table t(i,j) time needed between nodes when there is no congestion
         v1      v2      v3      v4      v5      v6      v7      v8      v9
v1       2000    49      53      39      40      42      47      36      38
v2       49     2000     30     2000    2000    2000    2000    2000     36
v3       53      30     2000     33     2000    2000    2000    2000    2000
v4       39     2000     33     2000     35     2000    2000    2000    2000
v5       40     2000    2000     35     2000     41     2000    2000    2000
v6       42     2000    2000    2000     41     2000     25     2000    2000
v7       47     2000    2000    2000    2000    25      2000     32     2000
v8       36     2000    2000    2000    2000    2000     32     2000     33
v9       38      36     2000    2000    2000    2000    2000     33     2000  ;


table d(i,j) commuters demand between each area at 8:15
         v1      v2      v3      v4      v5      v6      v7      v8      v9
v1               10                      30      20
v2       150                                                             40
v3       30                      90      20      30
v4       50
v5       92                      80                                      22
v6       50
v7       90                      25              10
v8       50                                      10      3               10
v9       40                                                                  ;

variables
x(i,j)
w(i,j,k)
z;

positive variables x, w;

equations
cons1(i,j)    amount of people using road (i-j)
cons2(i,j)    flow balance
cons3(i)      right amount of cars are launched from i
obj           obj funct;

cons1(i,j)                       .. x(i,j) =E= sum(k,w(k,i,j));
cons2(i,j)$(ord(i) ne ord(j))    .. d(i,j) =E= sum(k, w(i,k,j) - w(i,j,k));
cons3(i)                         .. sum(j,d(i,j)) =E= sum(j, w(i,i,j));
obj                              .. z =E= sum((i,j),x(i,j)*t(i,j));

model project /all/;
solve project using lp minimize z;

display x.l , z.l, w.l;

