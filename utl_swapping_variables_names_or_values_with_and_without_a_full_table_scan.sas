Swapping variables names or values with and without a full table scan.

   Four solutions

      1. FCMP call swapn and call swapc
      2. Ordered rename with a retain  ie rename= firstName=LastName lastName=firstName
      3. Sql view or a create table
      4. Fastest double modify using proc datasets

INPUT
=====

  WORK.HAVE total obs=1

    FIRSTNAME    LASTNAME    FIRSTWORD    LASTWORD

    DeAngelis     Roger      Holidays      Happy

OUTPUT
======

  WORK.WANT total obs=1

    FIRSTNAME    LASTNAME     FIRSTWORD    LASTWORD

      Roger      DeAngelis      Happy      Holidays



ALLTHE CODE
============

 1  http://www.skythisweek.info/swap.htm

    options cmplib = (work.functions /* add other libs here */);
    proc fcmp outlib=work.functions.swap;

      subroutine swapn(a,b);
      outargs a, b;
          h = a; a = b; b = h;
      endsub;

      subroutine swapc(a $,b $);
      outargs a, b;
          h = a; a = b; b = h;
      endsub;
    run;quit;

    data want;

      set have;
      call swapc(firstName,LastName);
      call swapc(firstWord,LastWord);

    run;quit;


 2  data _null_; <datanull@GMAIL.COM>
    data want;

     retain firstname lastname firstword lastword;

     set have(rename=(
         firstName=LastName lastName=firstName
         firstWord=LastWord lastWord=firstWord
    ));

    run;quit;

  3 Carl Denney <carldenney@COMCAST.NET>
    proc datasets library=work;
      modify have;
       rename
        lastName   = lastName1
        firstName  = firstName1
        lastWord   = lastWord1
        firstWord  = firstWord1
    ;run;

      modify have;
       rename
        lastName1  =  firstName
        firstName1 =  LastName
        lastWord1  =  firstWord
        firstWord1 =  LastWord
    ;
    run;quit;


 4  Carl Denney <carldenney@COMCAST.NET>
    proc sql;
       create
          view wantVue as
       select
          lastName   as  firstName
         ,firstName  as  LastName
         ,lastWord   as  firstWord
         ,firstWord  as  LastWord
       from
          have
    ;quit;

OUTPUT
======

  WORK.WANT total obs=1

    FIRSTNAME    LASTNAME     FIRSTWORD    LASTWORD

      Roger      DeAngelis      Happy      Holidays



