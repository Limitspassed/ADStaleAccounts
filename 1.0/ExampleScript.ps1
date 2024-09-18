Import-Module ADStaleAccounts

$OU = "OU=TestUsers,DC=example,DC=com"
$Domain = "example.com"
$ReportPath = "C:\temp\test.txt"

Create-ADTestUsers -OU $OU -Domain $Domain

Clean-ADStaleUsers -GetLastLoggedIn Yes -DeleteStaleAccounts Yes -GenerateReport Yes -ReportPath $ReportPath -OU $OU -Verbose