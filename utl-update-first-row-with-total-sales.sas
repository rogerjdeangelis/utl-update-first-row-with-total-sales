Simply stated problems tend to illicit learning.

 Update first row with total sales

  Five Solutions

   1. Monotonic and ifn (ingenious) by Novinosrin (provides insight uses ifn and montonic)
      https://communities.sas.com/t5/user/viewprofilepage/user-id/138205

   2. My proc report with output dataset

   3. SQL union of sum record with the rest by Draycut
      https://communities.sas.com/t5/user/viewprofilepage/user-id/31304

   4. SQL case to do the sum first by Kurt Bremser
      https://communities.sas.com/t5/user/viewprofilepage/user-id/11562

   5. HASH by Novinosrin
      https://communities.sas.com/t5/user/viewprofilepage/user-id/138205

github
https://tinyurl.com/yah7q5dd
https://github.com/rogerjdeangelis/utl-update-first-row-with-total-sales

SAS Forum
https://tinyurl.com/y8tx6ht2
https://communities.sas.com/t5/SAS-Programming/Add-total-to-first-row/m-p/518699


INPUT
=====
                      | RULES
WORK.HAVE total obs=4 |
                      |
  COUNTRY    SALES    |
                      |
   World       25     |  Update Sales for World with (25+30+40+70)=165
   India       30     |
   USA         40     |
   Pak         70     |

EXAMPLE OUTPUT
--------------

 WORK.WANT total obs=4

  COUNTRY    SALES

   World      165   ** updated
   India       30
   USA         40
   Pak         70

PROCESS
========


 1. Monotonic and ifn (ingenious) by Novinosrin

    proc sql;
    create table want as
    select country, ifn(monotonic()=1,sum(sales),sales) as sales
    from have
    order by monotonic();
    quit;

 2. My proc report with output dataset

    proc report data=have out=want (where=(country ne "X") drop=_:);
    column Country Sales;
    define country/order descending;
    rbreak before /summarize;
    compute country;
      if country="" then country="World";
      else if country="World" then country="X";
    endcomp;
    run;

 3. SQL union of sum record with the rest by Draycut

    proc sql;
       create table want as
       select 'World' as country, sum(sales) as sales from have
       union
       select * from have where country ne 'World'
       order by sales descending;
    quit;

 4. SQL case to do the sum first by Kurt Bremser

    proc sql;
    create table want as
    select
      country,
      case
        when country = 'World' then (select sum(sales) from have)
        else sales
      end as sales
    from have;
    quit;

 5. HASH by Novinosrin

    data _null_ ;
    if _n_=1 then do;
       declare hash H (ordered:'a') ;
       h.definekey  ("_n_") ;
       h.definedata ("country", "sales") ;
       h.definedone () ;
       end;
    do _n_=nobs to 1 by -1;
    set have nobs=nobs point=_n_;
    k+sales;
    if _n_=1 then sales=k;
    rc=h.add();
    end;
    h.output(dataset:'want');
    stop;
    run;

 *                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;

data have;
input country $ sales;
cards4;
World 25
India 30
USA 40
Pak 70
;;;;
run;quit;



