function Remove-ADStaleComputers {

    <#
    .SYNOPSIS
    Removes stale Active Directory computer accounts based on last logon date.
    
    .DESCRIPTION
    The Remove-ADStaleComputers function identifies computer accounts in a specified Organizational Unit (OU) that have not logged in for over 90 days or have never logged in. It provides options to generate a report and delete stale accounts.
    
    .PARAMETER GetLastLoggedIn
    Specifies whether to check the last logged-in dates of computer accounts. Accepts "Yes" or "No".
    
    .PARAMETER DeleteStaleAccounts
    Specifies whether to delete accounts identified as stale. Accepts "Yes" or "No".
    
    .PARAMETER GenerateReport
    Indicates if a report should be created. Accepts "Yes" or "No".
    
    .PARAMETER ReportPath
    Path for the output report file. The report will log details of computers that have not logged in and any deletions performed.
    
    .PARAMETER OU
    The Organizational Unit in which to search for user accounts.
    
    .EXAMPLE
    Remove-ADStaleComputers -GetLastLoggedIn "Yes" -DeleteStaleAccounts "Yes" -GenerateReport "Yes" -ReportPath "C:\Reports\StaleUsersReport.txt" -OU "OU=Computers,DC=example,DC=com"
    This command checks for stale computer accounts in the specified OU, deletes those that have not logged in for over 90 days, and generates a report at the specified path.
    
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
    $Array = @()
    
    $ADComputers = Get-ADComputer -Filter * -Properties * -SearchBase $OU | Select-Object SamAccountName, LastLogonDate
    
    if ($GetLastLoggedIn -eq "Yes"){
        $Array = foreach ($ADComputer in $ADComputers){
            if ($ADComputer.LastLogonDate -ne $null -and $ADComputer.LastLogonDate -lt $Date.AddDays(-90)) {
                if ($GenerateReport -eq "Yes") {
                    $ReportText = "$($ADComputer.SamAccountName) last logged in on $($ADComputer.LastLogonDate)."
                    $ADComputer
                    $ReportText | Out-File $reportPath -Append | Sort-Object -Descending
                    Write-Verbose "$($ADComputer.SamAccountName) last logged in on $($ADComputer.LastLogonDate)."
                }
            } elseif ($ADComputers.SamAccountName -notin $Ignore -and $ADComputer.lastlogonDate -eq $null) {
                if ($GenerateReport -eq "Yes") {
                    $ReportText = "$($ADComputer.SamAccountName) has never logged on."
                    $ADComputer
                    $ReportText | Out-File $ReportPath -Append | Sort-Object -Descending
                    Write-Verbose "$($ADComputer.SamAccountName) has never logged in"
                }
            }
        }
    }

    foreach ($ADComputer in $Array){
        if ($DeleteStaleAccounts -eq "Yes"){
            if ($ADComputer.LastLogonDate -ne $null -or $ADComputer.LastLogonDate -lt $Date.AddDays(-90)){
            $ReportText = "$($ADComputer.SamAccountName) has been deleted"
            if ($GenerateReport -eq "Yes") {
                $ReportText | Out-File $ReportPath -Append | Sort-Object -Descending
            }
            Write-Verbose "$($ADComputer.SamAccountName) has been deleted"
            Remove-ADComputer $ADComputer.SamAccountName -Confirm:$false
            }
        } else {
        Write-Verbose "$($ADComputer.SamAccountName) would have been deleted"
        }
    }
}