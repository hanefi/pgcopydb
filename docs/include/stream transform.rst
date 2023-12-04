::

   pgcopydb stream transform: Transform changes from the source database into SQL commands
   usage: pgcopydb stream transform  <json filename> <sql filename> 
   
     --source         Postgres URI to the source database
     --dir            Work directory to use
     --restart        Allow restarting when temp files exist already
     --resume         Allow resuming operations after a failure
     --not-consistent Allow taking a new snapshot on the source database

