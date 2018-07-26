Table of Contents
-------------------

 * [Installation](#installation)
 * [Quick Start](#quick-start)
 * [Persistence](#persistence)

Installation
-------------------

 * [Install Docker 1.9+](https://docs.docker.com/installation/) or [askubuntu](http://askubuntu.com/a/473720)
 * Pull the latest version of the image.
 
```bash
$ docker pull rafaelhumberto/mssql-linux:developer
```

Alternately you can build the image yourself.

```bash
$ git clone https://github.com/rafaelhumberto/mssql-linux.git
$ cd mssql-linux
$ docker build -t="$USER/mssql-linux" .
```

Quick Start
-------------------

This image contains:

  * Latest version of SQL Server 2017 Developer Edition for Linux
  * SQL Server Command-Line Tools (sqlcmd, bcp)
  * Full-Text Search Features
  * SQL Agent Features
  * Availability Group Features
  * Default data dir `/var/opt/mssql/data/`
  * Default log dir `/var/opt/mssql/log/`
  * Traceflags 1117 1118 1222 1224
  * Healthcheck script for docker-compose file

Run the database container:

```bash
$ docker run --name mssql-instance -d -p 1433:1433 -e SA_PASSWORD='<YourStrong!Passw0rd>' -e ACCEPT_EULA='Y' rafaelhumberto/mssql-linux:developer
```

The simplest way to login to the database container is to use the `docker exec` command to attach a new process to the running container.

```bash
$ docker exec -it mssql-instance bash
```

Persistence
-------------------

For development a volume should be mounted at `/var/opt/mssql/`.

The updated run command looks like this.

```bash
$ docker run --name mssql-instance -d -p 1433:1433 \
  -e SA_PASSWORD='<YourStrong!Passw0rd>' -e ACCEPT_EULA='Y' \
  -v /host/to/path/mssql:/var/opt/mssql/ \
  rafaelhumberto/mssql-linux:developer
```
