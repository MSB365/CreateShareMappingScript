<#     
       .NOTES
       ==============================================================================
       Created on:         2022/01/13 
       Created by:         Drago Petrovic | Sandro Schmocker
       Organization:       MSB365.blog
       Filename:           CreateShareMappinScript.ps1
       Current version:    V1.10     
       Find us on:
             * Website:         https://www.msb365.blog
             * Technet:         https://social.technet.microsoft.com/Profile/MSB365
             * LinkedIn:        https://www.linkedin.com/in/drago-petrovic/
             * MVP Profile:     https://mvp.microsoft.com/de-de/PublicProfile/5003446
       ==============================================================================
       .DESCRIPTION
       This scripts creates a PowerShell Script for Network Drive mappings. The created Script can be uploaded to Microsoft Intune           
       
       .NOTES
       Short Documentation about this Script can be found on https://www.msb365.blog/?p=4669
        


       .EXAMPLE
       .\CreateShareMappinScript.ps1
             
       .COPYRIGHT
       Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
       to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
       and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
       The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
       THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
       FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
       WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
       ===========================================================================
       .CHANGE LOG
             V1.00, 2022/01/12 - SaSc - Initial version
			 V1.10, 2022/01/13 - DrPe - Script modified with several options -> Go live


			 
--- keep it simple, but significant ---
--- by MSB365 Blog ---
#>
Write-Host "Welcome to the Network Share Configurator" -ForegroundColor Magenta
Write-Host ""
Start-Sleep -s 5
Write-Host ""
Write-Host ""
#####################################################################################################
# Enter variables
Write-Host "You will need to input the variables for the configuration" -ForegroundColor Cyan
Write-Host ""
$customer = Read-Host "Please enter Name of Customer"
Write-Host ""
$letter =  $(Write-Host "Please Choose your Drive letter. Example: " -NoNewLine) + $(Write-Host """" -NoNewline) +$(Write-Host "H" -ForegroundColor Yellow -NoNewline; Read-Host """")
$RegistryPath = "HKCU:\Network\$($letter)"
$NetworkPath = $(Write-Host "Please enter the Network Location. Example: " -NoNewLine) + $(Write-Host """" -NoNewline) +$(Write-Host "\\share\folder" -ForegroundColor Yellow -NoNewline; Read-Host """")
$directory1 = "C:\MDM\Network_Share_Configuration\$customer"



#####################################################################################################
# Check or create MDM Directory
$directory1 = "C:\MDM\Network_Share_Configuration\$customer"
Write-Host "Checking if $directory1 is available..." -ForegroundColor Magenta
Start-Sleep -s 1
If ((Test-Path -Path $directory1) -eq $false)
{
        Write-Host "The Directory $directory1 don't exists!" -ForegroundColor Cyan
        Start-Sleep -s 2
        Write-Host "Creating directory $directory1 ..." -ForegroundColor Cyan
        Start-Sleep -s 2
        New-Item -Path $directory1 -ItemType directory
        Start-Sleep -s 2
        Write-Host "New Directory $directory1 is is created" -ForegroundColor Green
        Start-Sleep -s 2
}else{
Write-Host "The Path $directory1 already exists" -ForegroundColor green
Start-Sleep -s 3
}

#####################################################################################################
# Set Regestry Keys
write-host "Configure Network share..." -ForegroundColor Magenta
Start-Sleep -s 3
write-host "Setting Registry keys..." -ForegroundColor Cyan
Start-Sleep -s 2
$script=@"
New-Item -Path HKCU:\Network\$($letter)
New-ItemProperty -Path $RegistryPath -Name "ConnectionType" -Value "1" -PropertyType DWORD -Force 
New-ItemProperty -Path $RegistryPath -Name "DeferFlags" -Value "4" -PropertyType DWORD -Force 
New-ItemProperty -Path $RegistryPath -Name "ProviderName" -Value "Microsoft Windows Network" -PropertyType String -Force 
New-ItemProperty -Path $RegistryPath -Name "ProviderType" -Value "20000" -PropertyType DWORD -Force 
New-ItemProperty -Path $RegistryPath -Name "RemotePath" -Value "$NetworkPath" -PropertyType String -Force 
New-ItemProperty -Path $RegistryPath -Name "UserName" -Value "0" -PropertyType DWORD -Force 
New-ItemProperty -Path $RegistryPath -Name "UseOptions" -PropertyType Binary -Force 
"@
Start-Sleep -s 2
write-host "Regestry keys set!" -ForegroundColor Green
Start-Sleep -s 5
write-host "Creating new Item for Network share..." -ForegroundColor Cyan
Start-Sleep -s 2
New-Item -Path "$directory1" -Name "Network_Shares_$($customer)_$($letter).ps1" -Force -Value $script
Write-Host "Network share $letter linked!" -ForegroundColor Green
Start-Sleep -s 3
write-host "Configuration finished!" -BackgroundColor green -ForegroundColor Black
Start-Sleep -s 3
#####################################################################################################
Write-Host "NOTE:" -BackgroundColor White -ForegroundColor Black 
write-host "The final script is now created and stored at $directory1 and can be uploaded to Microsoft Intune " -ForegroundColor black -BackgroundColor Yellow
