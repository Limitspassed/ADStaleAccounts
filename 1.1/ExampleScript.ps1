Import-Module ADStaleAccounts

$UsersOU = "OU=LPUsers,DC=limitspassed,DC=corp"
$ComputersOU = "OU=LPComputers,DC=limitspassed,DC=corp"
$Domain = "limitspassed.corp"
$UsersReportPath = "C:\temp\userstest.txt"
$ComputersReportPath = "C:\temp\computerstest.txt"

Create-ADTestUsers -OU $UsersOU -Domain $Domain

Clean-ADStaleUsers -GetLastLoggedIn Yes -DeleteStaleAccounts Yes -GenerateReport Yes -ReportPath $UsersReportPath -OU $UsersOU -Verbose


Create-ADTestComputers -OU $ComputersOU

Clean-ADStaleComputers -GetLastLoggedIn Yes -DeleteStaleAccounts Yes -GenerateReport Yes -ReportPath $ComputersReportPath -OU $ComputersOU -Verbose