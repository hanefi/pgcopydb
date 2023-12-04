::

   pgcopydb stream sentinel create: Create the sentinel table on the source database
   usage: pgcopydb stream sentinel create  --source ... 
   
     --source      Postgres URI to the source database
     --startpos    Start replaying changes when reaching this LSN
     --endpos      Stop replaying changes when reaching this LSN

