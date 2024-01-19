# pgcopydb extension for PostgreSQL written in Rust

This project uses [pgrx](https://github.com/pgcentralfoundation/pgrx) to build a
PostgreSQL extension written in Rust that provides a SQL interface to pgcopydb.

## Installation

TODO: Add installation instructions.

## Usage

```sql
-- You can run arbitrary pgcopydb commands from the command line by supplying an array of
-- arguments to the pgcopydb function.
SELECT pgcopydb(ARRAY['clone', '--source', 'postgresql://hanefi@localhost:28815/pgcopydb', '--target', 'postgresql://hanefi@localhost:28815/target'])

-- You can also start a clone command by supplying source and target connection strings,
-- as well as an array of extra arguments.
SELECT pgcopydb_clone('postgresql://hanefi@localhost:28815/pgcopydb', 'postgresql://hanefi@localhost:28815/target', ARRAY['--restart']);

-- You can set the connection strings as variables and use them in the pgcopydb function
-- for easy testing.
SELECT 'postgresql://hanefi@localhost:28815/pgcopydb' source \gset
SELECT 'postgresql://hanefi@localhost:28815/target' target \gset

-- Use the variables in the pgcopydb_clone function.
SELECT pgcopydb_clone(:'source', :'target', ARRAY['--restart']);

-- You can also use the pgcopydb_list_progress function to see the progress of the clone
-- command.
--
-- This function also adds `--json` and `--summary` arguments to `pgcopydb list progress`
-- command for improved readability and json outputs. However, the return type is still
-- `text`.
SELECT pgcopydb_list_progress(:'source');
```
