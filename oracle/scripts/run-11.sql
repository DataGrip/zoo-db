-- The entry point for Oracle 11.2 non-CDB.
--
-- This is the only file mounted into the directory the container's setup
-- runner scans, so it is the only script that runner starts. Everything else
-- (the directory 'content', a copy of DB/Oracle) is mounted at /content,
-- outside of that directory, and is started from here in the order
-- that create-11.sql itself defines.
--
-- The path below must be absolute, it starts with the root of the container's
-- file system. Inside /content the scripts refer to each other with '@@'
-- and relative paths, that are resolved relative to the calling script.

@/content/create-11.sql

