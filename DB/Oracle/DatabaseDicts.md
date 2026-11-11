# Oracle Data Dictionary Access

## 1. View Accessibility and Container Visibility

Access was tested on Oracle Database 12.2, separately from the CDB root
and from a PDB, using connections with no dictionary access privileges,
`SELECT_CATALOG_ROLE`, `SELECT ANY DICTIONARY`, and `SYS`.
The database contained one open PDB (`READ WRITE`) and two other PDBs
in `MOUNTED` mode.

Each view was tested using a query of the following form:

```sql
SELECT 1
FROM SYS.DBA_PDBS
WHERE ROWNUM <= 1;
```

For `V$CONTAINERS` and `V$PDBS`, the queries use the underlying view names
`SYS.V_$CONTAINERS` and `SYS.V_$PDBS`. The `V$...` names normally refer to
public synonyms. On a CDB root connection with `SELECT ANY DICTIONARY`, queries against
`SYS.V$CONTAINERS` and `SYS.V$PDBS` failed with `ORA-00942`, whereas queries
against `SYS.V_$CONTAINERS` and `SYS.V_$PDBS` succeeded.

**Yes** means that SELECT succeeded, including queries returning no rows.
**No** means that the query failed with
`ORA-00942: table or view does not exist`.

For the first three views, successful cells describe the visible containers.
`PDB$SEED` is excluded throughout. **Current PDB** means the PDB to which
the session is connected. **All PDBs** means all non-seed PDBs in the tested
database, including both open and mounted PDBs. `CDB$ROOT` is the standard
Oracle root container name. When it is not listed in a cell, it was not visible.
The current container was verified using `SYS_CONTEXT('USERENV', 'CON_NAME')`.

Container names were queried without a row limit, using `NAME` in
`SYS.V_$CONTAINERS` and `SYS.V_$PDBS`, and `PDB_NAME` in `SYS.DBA_PDBS`.
For example:

```sql
SELECT SYS_CONTEXT('USERENV', 'CON_NAME') AS CURRENT_CONTAINER,
       COUNT(*) AS VISIBLE_CONTAINER_COUNT,
       LISTAGG(NAME, ', ') WITHIN GROUP (ORDER BY NAME) AS VISIBLE_CONTAINERS
FROM SYS.V_$CONTAINERS
WHERE NAME <> 'PDB$SEED';
```

| Container | Privileges / user | `V$CONTAINERS` | `V$PDBS` | `DBA_PDBS` | `DBA_CONTAINER_DATA` |
| --- | --- | --- | --- | --- | --- |
| CDB root | No dictionary privileges | No | No | No | No |
| CDB root | `SELECT_CATALOG_ROLE` | Yes: `CDB$ROOT` and all PDBs | Yes: all PDBs | Yes: all PDBs | Yes |
| CDB root | `SELECT ANY DICTIONARY` | Yes: `CDB$ROOT` and all PDBs | Yes: all PDBs | Yes: all PDBs | Yes |
| CDB root | `SYS` | Yes: `CDB$ROOT` and all PDBs | Yes: all PDBs | Yes: all PDBs | Yes |
| PDB | No dictionary privileges | No | No | No | No |
| PDB | `SELECT_CATALOG_ROLE` | Yes: current PDB only | Yes: current PDB only | Yes: current PDB only | Yes (empty) |
| PDB | `SELECT ANY DICTIONARY` | Yes: current PDB only | Yes: current PDB only | Yes: current PDB only | Yes (empty) |
| PDB | `SYS` | Yes: current PDB only | Yes: current PDB only | Yes: current PDB only | Yes (empty) |

With `SELECT_CATALOG_ROLE`, `SELECT ANY DICTIONARY`, or `SYS`, queries
from the CDB root showed all non-seed PDBs in all three views, including
the two mounted PDBs. Only `V$CONTAINERS` also showed `CDB$ROOT`.
Queries from a PDB showed only the current PDB in all three views;
other PDBs and `CDB$ROOT` were not visible, including for `SYS`.

These are observations for the tested database and session configuration.
Listing a container does not establish access to the data stored inside it.
