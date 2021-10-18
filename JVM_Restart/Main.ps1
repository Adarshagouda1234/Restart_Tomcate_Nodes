$URLListFile = "D:\Temp\AG91844\Nextgen_Prod\JVM_Restart\ServerList.txt"
$URLList = Get-Content $URLListFile -ErrorAction SilentlyContinue
$Action_Stop=''
$Action_ClearCache=''
$Action_Start=''
$Result=''


Foreach($Uri in $URLList)
{
        $computername=($Uri.Split(':'))[0]

        #$Action_Stop="Stop"
        #$Action_ClearCache="ClearTemp"
        #$Action_Start="Start"

        $arg_list=@($Uri,
        $Action_Stop,
        $Action_ClearCache,
        $Action_Start
        )
        #$return_value=Invoke-Command -FilePath D:\Temp\AG91844\Nextgen_Prod\JVM_Restart\Restart_JVM.ps1 -ComputerName $computername -ArgumentList $arg_list
        $return_value=Invoke-Command -FilePath D:\Temp\AG91844\JVM_Restart\Test.ps1 -ComputerName $computername -ArgumentList $arg_list
        $Result += " $Uri `n $return_value "        
}

$From = "Gouda, Adarsha <Adarsha.Gouda@legatohealth.com>"
$To = "Gouda, Adarsha <Adarsha.Gouda@legatohealth.com>"
$Subject = "JVM Restart"
$Body = "$Result"
$SMTPServer = "smtp.wellpoint.com"
$SMTPPort = "25"		
Send-MailMessage -From $From -to $To -Subject $Subject -Body $Body -SmtpServer $SMTPServer -port $SMTPPort –DeliveryNotificationOption OnSuccess


echo 'completed Restart '
