.. _pgcopydb_dump:

pgcopydb dump
=============

pgcopydb dump - Dump database objects from a Postgres instance

This command prefixes the following sub-commands:

.. include:: ../include/dump.rst

.. _pgcopydb_dump_schema:

pgcopydb dump schema
--------------------

pgcopydb dump schema - Dump source database schema as custom files in target directory

The command ``pgcopydb dump schema`` uses pg_dump to export SQL schema
definitions from the given source Postgres instance.

.. include:: ../include/dump-schema.rst

.. _pgcopydb_dump_roles:

pgcopydb dump roles
-------------------

pgcopydb dump roles - Dump source database roles as custome file in work directory

The command ``pgcopydb dump roles`` uses pg_dumpall --roles-only to export
SQL definitions of the roles found on the source Postgres instance.

.. include:: ../include/dump-roles.rst

The ``pg_dumpall --roles-only`` is used to fetch the list of roles from the
source database, and this command includes support for passwords. As a
result, this operation requires the superuser privileges.

It is possible to use the option ``--no-role-passwords`` to operate without
superuser privileges. In that case though, the passwords are not part of the
dump and authentication might fail until passwords have been setup properly.


Description
-----------

The ``pgcopydb dump schema`` command implements the first step of the full
database migration and fetches the schema definitions from the source
database.

When the command runs, it calls ``pg_dump`` to get the pre-data schema and
the post-data schema output in a Postgres custom file called ``schema.dump``.

The output files are written to the ``schema`` sub-directory of the
``--target`` directory.

Options
-------

The following options are available to ``pgcopydb dump schema`` subcommand:

--source

  Connection string to the source Postgres instance. See the Postgres
  documentation for `connection strings`__ for the details. In short both
  the quoted form ``"host=... dbname=..."`` and the URI form
  ``postgres://user@host:5432/dbname`` are supported.

  __ https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-CONNSTRING

--target

  Connection string to the target Postgres instance.

--dir

  During its normal operations pgcopydb creates a lot of temporary files to
  track sub-processes progress. Temporary files are created in the directory
  specified by this option, or defaults to
  ``${TMPDIR}/pgcopydb`` when the environment variable is set, or
  otherwise to ``/tmp/pgcopydb``.


--no-role-passwords

  Do not dump passwords for roles. When restored, roles will have a null
  password, and password authentication will always fail until the password
  is set. Since password values aren't needed when this option is specified,
  the role information is read from the catalog view pg_roles instead of
  pg_authid. Therefore, this option also helps if access to pg_authid is
  restricted by some security policy.

--snapshot

  Instead of exporting its own snapshot by calling the PostgreSQL function
  ``pg_export_snapshot()`` it is possible for pgcopydb to re-use an already
  exported snapshot.

--verbose

  Increase current verbosity. The default level of verbosity is INFO. In
  ascending order pgcopydb knows about the following verbosity levels:
  FATAL, ERROR, WARN, INFO, NOTICE, DEBUG, TRACE.

--debug

  Set current verbosity to DEBUG level.

--trace

  Set current verbosity to TRACE level.

--quiet

  Set current verbosity to ERROR level.

Environment
-----------

Environment variables that begin with ``PGCOPYDB_`` can be set directly in the
environment or read from the ``.env`` file located in either 
``${XDG_CONFIG_HOME}/pgcopydb/.env`` or ``${HOME}/.config/pgcopydb/.env``.

PGCOPYDB_SOURCE_PGURI

  Connection string to the source Postgres instance. When ``--source`` is
  ommitted from the command line, then this environment variable is used.

Examples
--------

First, using ``pgcopydb dump schema``

::

   $ pgcopydb dump schema --source "port=5501 dbname=demo" --target /tmp/target
   09:35:21 3926 INFO  Dumping database from "port=5501 dbname=demo"
   09:35:21 3926 INFO  Dumping database into directory "/tmp/target"
   09:35:21 3926 INFO  Found a stale pidfile at "/tmp/target/pgcopydb.pid"
   09:35:21 3926 WARN  Removing the stale pid file "/tmp/target/pgcopydb.pid"
   09:35:21 3926 INFO  Using pg_dump for Postgres "12.9" at "/Applications/Postgres.app/Contents/Versions/12/bin/pg_dump"
   09:35:21 3926 INFO   /Applications/Postgres.app/Contents/Versions/12/bin/pg_dump -Fc --section pre-data --section post-data --file /tmp/target/schema/schema.dump 'port=5501 dbname=demo'


Once the previous command is finished, the pg_dump output file can be found
in ``/tmp/target/schema`` and is named ``schema.dump``. Additionally, other files
and directories have been created.

::

   $ find /tmp/target
   /tmp/target
   /tmp/target/pgcopydb.pid
   /tmp/target/schema
   /tmp/target/schema/schema.dump
   /tmp/target/run
   /tmp/target/run/tables
   /tmp/target/run/indexes
