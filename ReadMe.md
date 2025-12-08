Demo Database Schemas for Testing
=================================
         
This repository contains databases and schemas for static tests.
Databases are grouped by DBMS types, and schema files can be split 
by versions, editions or forks.
   
                         
Directory Layout
----------------

Root directories:
* **DB** — SQL scripts that create databases and schemas for testing
* **Docker** — scripts to create docker containers with databases

Both directories are organized by DBMS type. Right now, the following DBMSs are supported (code — vendor):
* **Microsoft** — Microsoft SQL Server
* **Oracle** — Oracle Database

The **DB** directory can be used for several purposes: 
- as a script directory for getting demo databases on a local machine
- to get scripts for creating containers with databases
                                                            
This directory doesn't belong to the containers' code 
and can be used independently without containers.

Please **don't mix SQL and container stuff**!

     
Code Style
----------

Key points:
* indent with 4 spaces
* tab is equivalent to 8 spaces when used
* use lower case for keywords
* never place a closing bracket (parenthesis, brace) in left of an opening one

For other style details see the existing files.
