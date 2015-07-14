# MySQL

## mysql.sh

Check the section `vars`.

# Install

It will install the last version available on your system.

```bash
./mysql.sh install
```

# Configure

It will replace the variables on `database.yml` files and copy it to config folder.
You need to provide the database password.

```bash
./mysql.sh configure {{database_password}}
```
