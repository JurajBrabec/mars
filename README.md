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
  -status              - Displays various status information.
  -start [db|http]     - Starts a service. Defaults to both services.
  -stop [db|http]      - Stops a service. Defaults to both services.
  -restart [db|http]   - Restarts a service. Defaults to both services.
  -disable             - Disables the scheduler.
  -enable              - Enables the scheduler (if it was disabled).

 Rarely used commands & parameters:
  -scheduler           - Executes the scheduler.
  -export [{database}] - Imports/exports a database. Defaults to all databases.
  -import [{database}] - Imports/exports a database. Defaults to all databases.
  -init                - initializes the database to default (empty) state.
  -webinterface        - Starts the web interface.
  -heidisql            - Starts the HeidiSQL tool.

 Commands used once (or never):
  -install             - installs MARS 4.1, Edit "%root%\install.ini" first.
  -uninstall           - uninstalls MARS 4.1 from the system.
