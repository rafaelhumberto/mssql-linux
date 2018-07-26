FROM microsoft/mssql-server-linux:latest

RUN apt-get update
RUN apt-get -y install curl software-properties-common
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN add-apt-repository "$(curl https://packages.microsoft.com/config/ubuntu/16.04/mssql-server-2017.list)"
RUN apt-get update
RUN apt-get install -y mssql-tools unixodbc-dev mssql-server-fts mssql-server-is xz-utils sharutils
RUN apt-get clean
RUN mkdir -p /var/opt/mssql/data
RUN mkdir -p /var/opt/mssql/log
RUN mkdir -p /var/opt/mssql/backup
RUN mkdir -p /var/opt/mssql/audit
RUN mkdir -p /var/opt/mssql/dump
RUN /opt/mssql/bin/mssql-conf set memory.memorylimitmb 4096
RUN /opt/mssql/bin/mssql-conf set sqlagent.enabled true
RUN /opt/mssql/bin/mssql-conf set hadr.hadrenabled 1
RUN /opt/mssql/bin/mssql-conf set telemetry.customerfeedback false
RUN /opt/mssql/bin/mssql-conf set filelocation.masterdatafile /var/opt/mssql/data/master.mdf
RUN /opt/mssql/bin/mssql-conf set filelocation.masterlogfile /var/opt/mssql/log/mastlog.ldf
RUN /opt/mssql/bin/mssql-conf set filelocation.defaultdatadir /var/opt/mssql/data
RUN /opt/mssql/bin/mssql-conf set filelocation.defaultlogdir /var/opt/mssql/log
RUN /opt/mssql/bin/mssql-conf set filelocation.defaultbackupdir /var/opt/mssql/backup
RUN /opt/mssql/bin/mssql-conf set filelocation.defaultdumpdir /var/opt/mssql/dump
RUN /opt/mssql/bin/mssql-conf set filelocation.errorlogfile /var/opt/mssql/errors
RUN /opt/mssql/bin/mssql-conf set telemetry.userrequestedlocalauditdirectory /var/opt/mssql/audit
RUN /opt/mssql/bin/mssql-conf traceflag 1117 1118 1222 1224 on
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN export PATH=/opt/ssis/bin:$PATH

ADD ssis.conf /var/opt/ssis/ssis.conf
RUN /opt/ssis/bin/ssis-conf -n setup

ADD healthcheck.sh /var/opt/mssql/healthcheck.sh
RUN chmod +x /var/opt/mssql/healthcheck.sh

EXPOSE 1433