# Restart_Tomcate_Nodes
.ps1 script can use to remote restart multiple Tomcat nodes located in different windows servers 

follw below steps before running the file
* WinRam config should be enable
* add the server and port details in "ServerList.txt" file in below formate
        * servername:port_no:service_name:type(user/admin/service/streeming)
* in "main.ps1" file:
             * $Action_Stop="Stop"  --> commient this line if you don't want to stop nodes
             * $Action_ClearCache="ClearTemp" --> commient this line if you don't want to cleate cache nodes
             * $Action_Start="Start" --> commient this line if you don't want to start nodes
