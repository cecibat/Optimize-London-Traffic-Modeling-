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


table a(i,j) coefficient delay for an amount of congestion
         v1      v2      v3      v4      v5      v6      v7      v8      v9
v1             0.3514  0.5155  0.3461  0.2989  0.5522  0.3667   0.4647  0.2306
v2    0.5098           0.2387                                           0.2021
v3    0.7478   0.2387          0.2105
v4    0.5021           0.2105          0.2846
v5    0.4337                   0.2846          0.2758
v6    0.8011                           0.2758          0.3776
v7    0.5320                                   0.3776            0.4833
v8    0.6742                                           0.4833           0.2261
v9    0.3345  0.2337                                             0.2261        ;



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

