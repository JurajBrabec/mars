MARS 4.1 READ ME
======================

HOW-TO INSTALL:
•	Edit "install.ini"
•	Run "MARS.CMD INSTALL"
•	For more information please refer to INSTALL guide.
HOW-TO UNINSTALL:
•	Run "MARS.CMD UNINSTALL"

•USAGE: MARS command [parameter]
 Command may be preceded by "/" (i.e. mars /install) or "-" (i.e. mars -install). Parameter must be bare.
 Comonly used commands & parameters:
 -disable             - Disables the scheduler.
 -enable              - Enables the scheduler (if it was disabled).
 -status              - Displays various status information.
 -start [db^|http]     - Starts a service. Defaults to both services.
 -stop [db^|http]      - Stops a service. Defaults to both services.
 Rarely used commands & parameters:
 -scheduler           - Executes the scheduler.
 -export [{database}] - Imports/exports a database. Defaults to all databases.
 -import [{database}] - Imports/exports a database. Defaults to all databases.
 -init                - initializes the database to default (empty) state.
 -webinterface        - Starts the web interface.
 -heidisql            - Starts the HeidiSQL tool.
