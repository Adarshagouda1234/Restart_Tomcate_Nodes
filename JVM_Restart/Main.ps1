$URLListFile = "<filelocation>\ServerList.txt" #add .txt file location here
$URLList = Get-Content $URLListFile -ErrorAction SilentlyContinue
$Action_Stop=''
$Action_ClearCache=''
$Action_Start=''
$Result=''


Foreach($Uri in $URLList)
{
        $computername=($Uri.Split(':'))[0]

        $Action_Stop="Stop"
        $Action_ClearCache="ClearTemp"
        $Action_Start="Start"

        $arg_list=@($Uri,
        $Action_Stop,
        $Action_ClearCache,
        $Action_Start
        )
        $return_value=Invoke-Command -FilePath <add file location here>\Restart_JVM.ps1 -ComputerName $computername -ArgumentList $arg_list
        
        $Result += " $Uri `n $return_value "        
}

#for mail notification
$From = "<add from mail address here>"
$To = "<add to mail address here>"
$Subject = "JVM Restart"
$Body = "$Result"
$SMTPServer = "<add smtp domain address>"
$SMTPPort = "25"		
Send-MailMessage -From $From -to $To -Subject $Subject -Body $Body -SmtpServer $SMTPServer -port $SMTPPort –DeliveryNotificationOption OnSuccess


echo 'completed Restart '
