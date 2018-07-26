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

Start SQL Server instance:

```bash
$ docker run --name mssql-instance -d -p 1433:1433 -e SA_PASSWORD='<YourStrong!Passw0rd>' -e ACCEPT_EULA='Y' rafaelhumberto/mssql-linux:developer
```

The simplest way to login to the database container is to use the `docker exec` command to attach a new process to the running container.

```bash
$ docker exec -it mssql-instance bash
$ sqlcmd -U sa -P $SA_PASSWORD
1> SELECT @@version;
2> GO
---------------------------------------------------------------------
Microsoft SQL Server 2017 (RTM-CU9) (KB4341265) - 14.0.3030.27 (X64)
        Jun 29 2018 18:02:47
        Copyright (C) 2017 Microsoft Corporation
        Developer Edition (64-bit) on Linux (Ubuntu 16.04.4 LTS)

(1 rows affected)
1> 
```

Start via docker stack deploy or docker-compose

Sample compose file:

```bash
version: "3.4"

services:
    mssql-instance:
        image: "rafaelhumberto/mssql-linux:developer"
        environment:
            ACCEPT_EULA: "Y"
            SA_PASSWORD: "<YourStrong!Passw0rd>"
            MSSQL_PID: "Developer"
            SSIS_PID: "Developer"
        ports:
            - 1433:1433
        volumes:
            - /host/to/path/mssql:/var/opt/mssql            
        deploy:
            resources:
                limits:
                    cpus: '4'
                    memory: 4G
                reservations:
                    cpus: '2'
                    memory: 3G
            mode: replicated
            replicas: 1
            restart_policy:
                condition: on-failure
                delay: 1m
                max_attempts: 3
                window: 1m
        healthcheck:
            test: ["CMD", "/var/opt/mssql/healthcheck.sh"]
            interval: 5s
            timeout: 3s
            retries: 3
            start_period: 1m
```

Run docker stack deploy 

```bash
$ docker stack deploy -c docker-compose.yml mssql-instance
```

or docker-compose up

```bash
$ docker-compose up -d
```

and wait for it to initialize completely.


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
