Function Create-ADTestComputers {

    <#
    .SYNOPSIS
    Creates test computer accounts in Active Directory.
    
    .DESCRIPTION
    The Create-ADTestComputers function generates a specified number of test computer accounts in a designated Organizational Unit (OU) within Active Directory.
    
    .PARAMETER OU
    The Organizational Unit where the test computer accounts will be created.
    
    .EXAMPLE
    Create-ADTestComputers -OU "OU=TestComputers,DC=example,DC=com"
    This command creates 10 test computer accounts.
    #>

    [CmdletBinding()]
    param(
        $OU
    )

    # Define base computer name
    $BaseComputerName = "TestComputer"

    # Loop to create 10 computers
    for ($i = 1; $i -le 10; $i++) {
        $ComputerName = "$BaseComputerName$i"
        
        # Create new AD computer
        New-ADComputer -Name $ComputerName `
                       -SamAccountName $ComputerName `
                       -Path $OU `
                       -PassThru `
                       -Enabled $true
                       
        Write-Host "Created computer account: $ComputerName"
    }
}