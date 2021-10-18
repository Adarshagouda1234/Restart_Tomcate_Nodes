        Param($Uri, $Action_Stop, $Action_ClearCache, $Action_Start)
        $computername=($Uri.Split(':'))[0]
        $port =($Uri.Split(':'))[1]
        $JVMNAME =($Uri.Split(':'))[2] 
        $Node_type='' 
        $Server=[System.Net.Dns]::GetHostByName((hostname)).HostName    
        $result=''
        $Action=''
        $stoptime=0 
        $TEMPPATH="D:\PEGA_TEMP\$JVMNAME\" 
        $NodeURL="https://$computername.us.ad.wellpoint.com:$port/prweb"
            echo "***** Node URL is $NodeURL  ****** `n"

         add-type @"

            using System.Net;   

            using System.Security.Cryptography.X509Certificates;   

            public class TrustAllCertsPolicy : ICertificatePolicy 
            {        

                public bool CheckValidationResult(ServicePoint srvPoint, X509Certificate certificate, WebRequest request, int certificateProblem) 
                {           

                    return true;        
                
                }    

            }

"@

[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy;

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Ssl3, [Net.SecurityProtocolType]::Tls, [Net.SecurityProtocolType]::Tls11, [Net.SecurityProtocolType]::Tls12

 


        if ((Get-Service -Name $JVMNAME -ErrorAction SilentlyContinue).length -eq 0)
        {

                echo " $JVMNAME does not exist in $computername `n"  

        }

        else 
        { 

                if ((Get-Service -Name $JVMNAME).StartType -eq 'Manual')
                {

                            echo " $JVMNAME is not enabled to run in $computername `n"       

                }

                else
                { 

                    $Action=$Action_Stop          

                    if ($Action -match 'Stop')
                    { 

                            echo " `n Stopping $JVMNAME in $computername `n "

                                while ((Get-Service $JVMNAME).status -ne 'stopped')
                                {

                                        if ($stoptime -eq 0 )
                                        {
                                                $Status=Stop-Service -Name $JVMNAME -Force 
                                                Start-Sleep 2
                                                $stoptime=$stoptime+2
                                                if((Get-Service $JVMNAME).Status -ne 'stopped')
                                                {   
                                                $pi=Get-Process -Id (Get-NetTCPConnection -LocalPort $port).OwningProcess | Select-Object -ExpandProperty ID #--> getting pid value
                                                taskkill /F /PID $pi
                                                }  

                                        } 

                                        <#if ($stoptime -gt 100 ) 
                                        { 
                                           
                                                $pi=Get-Process -Id (Get-NetTCPConnection -LocalPort $port).OwningProcess | Select-Object -ExpandProperty ID #--> getting pid value
                                                
                                                $Status= taskkill /F /PID $pi

                                                echo " `n Task was killed at $computername and $JVMNAME : $Status `n"

                                                echo " `n Stopped  $JVMNAME in $computername took $stoptime sec to respond...`n"

                                         }   

                                         start-sleep 2;    

                                         $stoptime=$stoptime+2; 
                                         #>
                                } 

                        if ($stoptime -le 80) 
                        {        

                            echo " `n Stopped  $JVMNAME in $computername `n " 

                        }          

                    }

                    $Action=$Action_ClearCache

                    if ($Action -match 'ClearTemp')
                    { 

                        echo " Clearing $JVMNAME temp files in $computername `n"               

                        remove-item -path $TEMPPATH\\* -recurse -force;               

                        echo " `n Cleared  $JVMNAME Temp files in $computername `n "         
                        Write-Host "temp was cleared in $JVMNAME in $computername "
                     }

                    $Action=$Action_Start

                    if ($Action -match 'Start')
                    {                
                    
                        echo " `n Starting $JVMNAME in $computername `n "

                        if((Get-Service $JVMNAME).status -ne 'Running')
                        {            

                        Start-Service $JVMNAME -WarningAction SilentlyContinue 
                        Write-Host " $JVMNAME service started in $computername "  
                        }

                        $Node_type=($Uri.Split(':'))[3]        
                        if($Node_type -eq 'Service' -or $Node_type -eq 'Admin' -or $Node_type -eq 'Bix' -or $Node_type -eq 'Streaming' -or $Node_type -eq 'Index' -or $Node_type -eq 'Pdf')
                        {
                        
                        $status=404;
                                          
                        $waittime=0;

                        Start-Sleep 5;               
                        
                        while ($status -ne 200 )               

                        {             

                            $webrspns='';                   
                            
                            try
                            {                       
                                                        
                                $status=(invoke-webrequest $NodeURL -UseBasicParsing -TimeoutSec 5).StatusCode                    
                                Write-Host " $status "
                             }                   

                             catch
                             {

                                $webrspns=$($_.Exception.Message)                   

                             }

                             $Remainder=0;                   

                             $tmp=[system.math]::DivRem($waittime,30,[ref]$Remainder);                   

                             if ($Remainder -eq 0)
                             {

                                echo " `n JVM is booting up, Time Elapsed: $waittime seconds `n "                   

                             }

                             start-sleep 5;                   

                             $waittime=$waittime+5;           

                         } 
                         
                         echo " `n Started  $JVMNAME in $computername in $Waittime seconds `n "          
                       }

                       echo " `n Started $JVMNAME in $computername `n "
                    
                     }


                 }   

         }
        

