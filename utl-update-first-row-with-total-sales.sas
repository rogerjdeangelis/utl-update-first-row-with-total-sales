Added two more solutions

   6. SQL Update

   7. R (want$SALES[1]<-sum(want$SALES) ** One liner;

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

 6. SQL Update

    proc sql undo_policy=none;
      update have as u
      set  sales=(select sum(sales) from have)
      where u.country='World'
    ;quit;


 7. R

    options validvarname=upcase;
    libname sd1 "d:/sd1";
    data sd1.have;
    input country $ sales;
    cards4;
    World 25
    India 30
    USA 40
    Pak 70
    ;;;;
    run;quit;

    %utlfkil(d:/xpt/want.xpt);
    %utl_submit_r64('
    library(haven);
    library(SASxport);
    want<-read_sas("d:/sd1/have.sas7bdat");
    want$SALES[1]<-sum(want$SALES);
    want<-as.data.frame(want);
    str(want);
    want;
    write.xport(want,file="d:/xpt/want.xpt");
    ');

    write.xport(want,file="d:/xpt/want.xpt");

    libname xpt xport "d:/xpt/want.xpt";
    data want;
         set xpt.want;
    run;quit;


