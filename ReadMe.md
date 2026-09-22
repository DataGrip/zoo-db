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
* * * NB!   All scripts for Microsoft SQL Server should be duplicated to `/mssql/scripts/` directory. Update `./mssql/scripts/scripts.json` if you add new scripts or remove ones.
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
        

Data Sources
------------

Normally, we configure a large number of data sources in this project.
However, it is currently challenging to separate shared and personal data sources,
because they are all stored in a single `dataSources.xml` file.
Therefore, we decided not to include this file (and also the  `db-forest-config.xml` file)
in the repository.


How to connect to databases in Kubernetes cluster  
------------------------------------------------- 

Use the following connection strings for testing:

`jdbc:sqlserver://datagripdb.labs.jb.gg:25140;username=Tourist;password=<PASSWORD>` for MS SQL Server 14  
`jdbc:sqlserver://datagripdb.labs.jb.gg:25150;username=Tourist;password=<PASSWORD>` for MS SQL Server 15  
`jdbc:sqlserver://datagripdb.labs.jb.gg:25160;username=Tourist;password=<PASSWORD>` for MS SQL Server 16

`jdbc:oracle:thin:Tourist/<PASSWORD>@datagripdb.labs.jb.gg:25110:XE`        for Oracle 11.2  non-CDB  
`jdbc:oracle:thin:Tourist/<PASSWORD>@datagripdb.labs.jb.gg:25111:ORCL`      for Oracle 12.2  non-CDB  
`jdbc:oracle:thin:Tourist/<PASSWORD>@datagripdb.labs.jb.gg:25112:ORCLCDB`   for Oracle 12.2  multitenant  
`jdbc:oracle:thin:Tourist/<PASSWORD>@datagripdb.labs.jb.gg:25113:ORCL`      for Oracle 19.3  non-CDB   
`jdbc:oracle:thin:Tourist/<PASSWORD>@datagripdb.labs.jb.gg:25114:ORCLCDB`   for Oracle 19.3  multitenant  
`jdbc:oracle:thin:Tourist/<PASSWORD>@datagripdb.labs.jb.gg:25115:XE`        for Oracle 21.3  multitenant
`jdbc:oracle:thin:Tourist/<PASSWORD>@datagripdb.labs.jb.gg:25116:FREE`      for Oracle 23.26 multitenant


Use the following connection strings for creating databases (not for testing):  
  
`jdbc:sqlserver://datagripdb.labs.jb.gg:25140;username=sa;password=<PASSWORD>` for MS SQL Server 14  
`jdbc:sqlserver://datagripdb.labs.jb.gg:25150;username=sa;password=<PASSWORD>` for MS SQL Server 15  
`jdbc:sqlserver://datagripdb.labs.jb.gg:25160;username=sa;password=<PASSWORD>` for MS SQL Server 16  

`jdbc:oracle:thin:SYS/<PASSWORD>@datagripdb.labs.jb.gg:25110:XE`        for Oracle 11.2  non-CDB  
`jdbc:oracle:thin:SYS/<PASSWORD>@datagripdb.labs.jb.gg:25111:ORCL`      for Oracle 12.2  non-CDB  
`jdbc:oracle:thin:SYS/<PASSWORD>@datagripdb.labs.jb.gg:25112:ORCLCDB`   for Oracle 12.2  multitenant  
`jdbc:oracle:thin:SYS/<PASSWORD>@datagripdb.labs.jb.gg:25113:ORCL`      for Oracle 19.3  non-CDB   
`jdbc:oracle:thin:SYS/<PASSWORD>@datagripdb.labs.jb.gg:25114:ORCLCDB`   for Oracle 19.3  multitenant  
`jdbc:oracle:thin:SYS/<PASSWORD>@datagripdb.labs.jb.gg:25115:XE`        for Oracle 21.3  multitenant  
`jdbc:oracle:thin:SYS/<PASSWORD>@datagripdb.labs.jb.gg:25116:FREE`      for Oracle 23.26 multitenant  

  
How to deploy to Kubernetes  
----------------------------  

While deploying, the image is pulled from the JetBrains registry and scripts are executed from
the mounted script directory. To run any environment locally, use the `Docker/docker-compose.yml` file.   
The images are built from the `Docker/.../XX.dockerfile` files. If you need to change any image, use the corresponding
Dockerfile, rebuild the image with the **same tag** and push it to the JetBrains registry. 	 

All changes in the repository are **automatically** merged into containers after they are pushed to the `master` branch.  
After changes arrive to the `master` branch, the deployment job runs in TeamCity and the container runs in its own pod. To check whether a deployment is successful, go to **TeamCity-IT**:    
[deploys](https://teamcity-it.intellij.net/buildConfiguration/KubernetesController_EksIrelandEuWest1_datagrip_services_teamcity_it_generated_project_DeployZooDb#all-projects)

Our default namespace in the K8s cluster is `datagrip-services`.  

  
### HELM charts:

`mssql` - For MS SQL databases. All scripts that must be started when a container is UP are in `./mssql/scripts` directory. 
**Update** `./mssql/scripts/scripts.json` if you add new scripts to `./DB/Microsoft/Zoo-25/` directory or remove ones.  

`oracle` - For Oracle databases. All scripts that must be started when a container is UP are in `./oracle/scripts` directory,
which duplicates `./DB/Oracle/Zoo-26/` — keep the copy in sync when you add or remove scripts.

The scripts execution order is spelled out by the `create-*.sql` scripts via the SQL\*Plus `@@` includes. 
* `./oracle/scripts/run-<ver>.sql` — a one-line entry point per version, mounted as the **only** file in the
  scanned directory (`/scripts` for 11.2, `/opt/oracle/scripts/setup` for the rest), so it is the only script
  the runner starts.  
* `./oracle/scripts/Zoo-26/` — the copy of the schema scripts from `./DB/Oracle/Zoo-26` directory, which are awoken by `run-<ver>.sql`  
  
`haproxy` - For Load Balancer deployment.  

### Skaffold

In case you need to update deployment manually, follow these steps:  
  
* To create and check a manifest file, run `skaffold render --output rendered.yaml`  
* Check if `rendered.yaml` is correct  
* Deploy with `kubectl apply -f rendered.yaml`  
OR  
run `skaffold render | kubectl apply -f` - for automatic deployment. 
