Function Create-ADTestUsers {

    <#
    .SYNOPSIS
    Creates test user accounts in Active Directory.
    
    .DESCRIPTION
    The Create-ADTestUsers function generates a specified number of test user accounts in a designated Organizational Unit (OU) within Active Directory. It sets a default password and ensures that accounts are enabled and have non-expiring passwords.
    
    .PARAMETER OU
    The Organizational Unit where the test user accounts will be created.
    
    .PARAMETER Domain
    The domain to which the user accounts will belong, used for the User Principal Name (UPN).
    
    .EXAMPLE
    Create-ADTestUsers -OU "OU=TestUsers,DC=example,DC=com" -Domain "example.com"
    This command creates 10 test user accounts in the specified OU with a default password and enabled status.
    #>

    [CmdletBinding()]
    param(
        $OU,
        $Domain
    )

    # Define user details
    $BaseUserName = "TestUser"
    $Password = "P@ssw0rd123"
    
    # Loop to create 10 users
    for ($i = 1; $i -le 10; $i++) {
        $UserName = "$BaseUserName$i"
        $UserPrincipalName = "$UserName@$domain"
        $DisplayName = "Test User $i"
        
        # Create new AD user
        New-ADUser -Name $DisplayName `
                   -GivenName "Test" `
                   -Surname "User$i" `
                   -SamAccountName $UserName `
                   -UserPrincipalName $UserPrincipalName `
                   -Path $OU `
                   -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) `
                   -PasswordNeverExpires $true `
                   -Enable $true `
                   -PassThru
        }
    }