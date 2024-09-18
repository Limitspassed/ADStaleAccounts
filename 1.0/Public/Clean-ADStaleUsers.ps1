function Clean-ADStaleUsers {

    <#
    .SYNOPSIS
    Cleans up stale Active Directory user accounts based on last logon date.
    
    .DESCRIPTION
    The Clean-ADStaleUsers function identifies user accounts in a specified Organizational Unit (OU) that have not logged in for over 90 days or have never logged in. It provides options to generate a report and delete stale accounts.
    
    .PARAMETER GetLastLoggedIn
    Specifies whether to check the last logged-in dates of user accounts. Accepts "Yes" or "No".
    
    .PARAMETER DeleteStaleAccounts
    Specifies whether to delete accounts identified as stale. Accepts "Yes" or "No".
    
    .PARAMETER GenerateReport
    Indicates if a report should be created. Accepts "Yes" or "No".
    
    .PARAMETER ReportPath
    Path for the output report file. The report will log details of users that have not logged in and any deletions performed.
    
    .PARAMETER OU
    The Organizational Unit in which to search for user accounts.
    
    .EXAMPLE
    Clean-ADStaleUsers -GetLastLoggedIn "Yes" -DeleteStaleAccounts "Yes" -GenerateReport "Yes" -ReportPath "C:\Reports\StaleUsersReport.txt" -OU "OU=Users,DC=example,DC=com"
    This command checks for stale user accounts in the specified OU, deletes those that have not logged in for over 90 days, and generates a report at the specified path.
    
    #>
    
    [CmdletBinding()]
    param(
        [ValidateSet("Yes", "No")][string]$GetLastLoggedIn = "No",
        [ValidateSet("Yes", "No")][string]$DeleteStaleAccounts = "No",
        [ValidateSet("Yes", "No")][string]$GenerateReport = "No",
        $ReportPath,
        $OU
    )
    
    if ($GenerateReport -eq "Yes"){
        if (Test-Path $ReportPath){
            Write-Host "Deleting $ReportPath for a fresh report"
            Remove-Item -Path $ReportPath
        } else {
        Write-Host "$ReportPath will create file as it doesn't exist"
        }
    }
    
    $Date = Get-Date
    $Ignore = @("Guest", "krbtgt")
    $Array = @()
    
    $ADUsers = Get-ADUser -Filter * -Properties * -SearchBase $OU | Select-Object SamAccountName, LastLogonDate
    
    if ($GetLastLoggedIn -eq "Yes"){
        $Array = foreach ($ADUser in $ADUsers){
            if ($ADUser.SamAccountName -notin $Ignore -and $ADUser.LastLogonDate -ne $null -and $ADUser.LastLogonDate -lt $Date.AddDays(-90)) {
                if ($GenerateReport -eq "Yes") {
                    $ReportText = "$($ADUser.SamAccountName) has never logged on."
                    $ADUser
                    $ReportText | Out-File $reportPath -Append | Sort-Object -Descending
                    Write-Verbose "$($ADUser.SamAccountName) last logged in on $($ADUser.LastLogonDate)."
                }
            } elseif ($ADUser.SamAccountName -notin $Ignore -and $ADUser.lastlogonDate -eq $null) {
                if ($GenerateReport -eq "Yes") {
                    $ReportText = "$($ADUser.SamAccountName) has never logged on."
                    $ADUser
                    $Reporttext | Out-File $ReportPath -Append | Sort-Object -Descending
                    Write-Verbose "$($ADUser.SamAccountName) has never logged in"
                }
            }
        }
    }

    foreach ($ADUser in $Array){
        if ($DeleteStaleAccounts -eq "Yes"){
            if ($ADUser.LastLogonDate -ne $null -or $ADUser.LastLogonDate -lt $Date.AddDays(-90)){
            $ReportText = "$($ADUser.SamAccountName) has been deleted"
            if ($GenerateReport -eq "Yes") {
                $ReportText | Out-File $ReportPath -Append | Sort-Object -Descending
            }
            Write-Verbose "$($ADUser.SamAccountName) has been deleted"
            Remove-ADUser $ADUser.SamAccountName -Confirm:$false
            }
        } else {
        Write-Verbose "$($ADUser.SamAccountName) would have been deleted"
        }
    }
}