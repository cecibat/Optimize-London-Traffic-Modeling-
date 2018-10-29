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


table d(i,j) commuters demand between each area at 17:00
         v1      v2      v3      v4      v5      v6      v7      v8      v9
v1               150     30      50      92      50      90      50      40
v2       10                                                              40
v3
v4                       90              80              25
v5       30              20
v6       20              30                              10      10
v7                                                                3
v8
v9               40                      22                      10             ;



table a(i,j) coefficient delay for an amount of congestion
         v1      v2      v3      v4      v5      v6      v7      v8      v9
v1             0.4603  0.6752  0.4534  0.3916  0.7233  0.4803   0.6087  0.3021
v2    0.3217           0.2065                                           0.2021
v3    0.4719   0.2065          0.1821
v4    0.3169           0.1821          0.2462
v5    0.2737                   0.2462          0.2385
v6    0.5056                           0.2385          0.3265
v7    0.3357                                   0.3265           0.4180
v8    0.4255                                           0.4180           0.1956
v9    0.2111  0.2021                                            0.1956        ;



table u(i,j) maximum capacity
         v1      v2      v3      v4      v5      v6      v7      v8      v9
v1              100      74      81      96      55      92      56     118
v2       100             94                                             119
v3       74      94             117
v4       81             117              92
v5       96                      92             111
v6       55                             111              50
v7       92                                     50               50
v8       56                                              50             109
v9       118   119                                               109          ;

variables
x(i,j)
w(i,j,k)
z;

positive variables x, w;

equations
cons1(i,j)    amount of people using road (i-j)
cons2(i,j)    flow balance
cons3(i)      right amount of cars are launched from i
cons4(i,j)    upper limit on road to not exceed capacity
obj           obj funct;

cons1(i,j)                     .. x(i,j)        =E= sum(k,w(k,i,j));
cons2(i,j)$(ord(i) ne ord(j))  .. d(i,j)        =E= sum(k, w(i,k,j) - w(i,j,k));
cons3(i)                       .. sum(j,d(i,j)) =E= sum(j,w(i,i,j));
cons4(i,j)                     .. x(i,j)        =l= 0.99*u(i,j);
obj                            .. z             =E= sum((i,j)$(u(i,j)>0),x(i,j)*
                                                         ( t(i,j)+ (a(i,j)*x(i,j)) / (u(i,j)-x(i,j)) ) );

model p2_less_basic_example /all/;
option nlp = snopt;
solve p2_less_basic_example using nlp minimize z;


display x.l , z.l, w.l;







