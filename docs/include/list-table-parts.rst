::

   pgcopydb list table-parts: List a source table copy partitions
   usage: pgcopydb list table-parts  --source ... 
   
     --source                      Postgres URI to the source database
     --force                       Force fetching catalogs again
     --schema-name                 Name of the schema where to find the table
     --table-name                  Name of the target table
     --split-tables-larger-than    Size threshold to consider partitioning
     --split-max-parts             Maximum number of jobs for Same-table concurrency 
     --skip-split-by-ctid          Skip the ctid split
     --estimate-table-sizes        Allow using estimates for relation sizes
     --connection-retry-timeout    Number of seconds to retry connecting before timing out
   
