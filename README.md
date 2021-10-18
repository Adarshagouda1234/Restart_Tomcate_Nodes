# Restart_Tomcate_Nodes
.ps1 script can use to remote restart multiple Tomcat nodes located in different windows servers 

follw below steps before running the file
* open files as admin mode
* By default file will pickup HOST credentials for remote servers
* credentials should have admin access for all servers
* WinRam config should be enabled in all remote servers
* add the server and port details in "ServerList.txt" file in below formate
        * servername:port_no:service_name:type(user/admin/service/streeming)
       
       # in "main.ps1" file:
              * $URLListFile = "<filelocation>\ServerList.txt" #add .txt file location here
              * $Action_Stop="Stop"  --> commient this line if you don't want to stop nodes
              * $Action_ClearCache="ClearTemp" --> commient this line if you don't want to cleate cache nodes
              * $Action_Start="Start" --> commient this line if you don't want to start nodes
              * $return_value=Invoke-Command -FilePath <add file location here>\Restart_JVM.ps1 -ComputerName $computername -ArgumentList $arg_list # add file location here
                     # for mail notification
                     $From = "<add from mail address here>"
                     $To = "<add to mail address here>"
                     $Subject = "JVM Restart"
                     $Body = "$Result"
                     $SMTPServer = "<add smtp domain address>"
                     $SMTPPort = "25" #default value		
                     Send-MailMessage -From $From -to $To -Subject $Subject -Body $Body -SmtpServer $SMTPServer -port $SMTPPort –DeliveryNotificationOption OnSuccess

       # in "restart.ps1" file:
              * $TEMPPATH="<add temp file location here >\$JVMNAME\" # add temp file location here
              * $NodeURL="https://$computername.<add domain name here >:$port/" # add domain id here for a web request/ url format


