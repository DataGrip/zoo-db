Demo Database Schemas for Testing
=================================
         
This repository contains databases and schemas for static tests.
Databases are grouped by DBMS types, and schema files can be split 
by versions, editions or forks.
          

Contributing
------------

Before contributing to the repository, 
please enable hooks which will help avoid errors. 
To do this, once after cloning the repository, 
run the following command being in the root directory of the repository:

```
git config core.hooksPath .githooks
```

Use branches for long-running tasks.
When the task is complete, use merge or rebase as you see best.

When merging a branch into the master branch, 
avoid back-merging (avoid merging the master branch into your one 
when you are not going to add more commits to your branch).
                                           
The commit message should be startet with a capital letter. 
The preferred format is:

```
Subsystem: Short description of the change
```
       
or just 

```
Short description
```

when the subsystem doesn't matter.
                       
When the message contains issue numbers or other references, 
please add them into the description (don't start the message with them).
                  
       
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
