# ADStaleAccounts Module

## Overview

The `ADStaleAccounts` module provides PowerShell functions to manage Active Directory user and computer accounts. It includes functionalities for creating test users and cleaning up stale accounts based on their last logon dates.

## Folder Structure

The repository is strucured as follows:

```
ADStaleAccounts/
├── 1.0/                                # Version directory
│   ├── Public/                         # Public scripts
│   │   ├── Create-ADTestComputers.ps1  # Script for creating test computers
│   │   ├── Create-ADTestUsers.ps1      # Script for creating test users
│   │   ├── Remove-ADStaleComputers.ps1 # Script for removing stale computer accounts
│   │   └── Remove-ADStaleUsers.ps1     # Script for removing stale user accounts
│   ├── ADStaleAccounts.psd1            # Module manifest file
│   ├── ADStaleAccounts.psm1            # The main PowerShell module file
│   └── ExampleScript.ps1               # Example usage script
└── ...
```

## Functions

### 1. Create-ADTestUsers

Creates a specified number of test user accounts in a designated Organizational Unit (OU) within Active Directory.

#### Parameters
- **OU**: The Organizational Unit where the test user accounts will be created.
- **Domain**: The domain for the User Principal Name (UPN).

#### Example 1:

```
$OU = "OU=TestUsers,DC=example,DC=com"
$Domain = "example.com"
Create-ADTestUsers -OU $OU -Domain $Domain
```

### 1. Create-ADTestComputers

Creates a specified number of test computer accounts in a designated Organizational Unit (OU) within Active Directory.

#### Parameters
- **OU**: The Organizational Unit where the test user accounts will be created.

#### Example

```
$OU = "OU=TestComputers,DC=example,DC=com"
Create-ADTestComputers -OU $OU
```

### 2. Remove-ADStaleUsers

Identifies and optionally deletes stale Active Directory user accounts based on their last logon date. It can also generate a report of the actions taken.

## Parameters

- GetLastLoggedIn: Specifies whether to check last logged-in dates ("Yes" or "No").
- DeleteStaleAccounts: Specifies whether to delete accounts identified as stale ("Yes" or "No").
- GenerateReport: Indicates if a report should be created ("Yes" or "No").
- ReportPath: Path for the output report file.
- OU: Organizational Unit to search for user accounts.

## Example

```
$OU = "OU=TestUsers,DC=example,DC=com"
$ReportPath = "C:\temp\test.txt"
Remove-ADStaleUsers -GetLastLoggedIn Yes -DeleteStaleAccounts Yes -GenerateReport Yes -ReportPath $ReportPath -OU $OU -Verbose
```

### 2. Remove-ADStaleComputers

Identifies and optionally deletes stale Active Directory computer accounts based on their last logon date. It can also generate a report of the actions taken.

## Parameters

- GetLastLoggedIn: Specifies whether to check last logged-in dates ("Yes" or "No").
- DeleteStaleAccounts: Specifies whether to delete accounts identified as stale ("Yes" or "No").
- GenerateReport: Indicates if a report should be created ("Yes" or "No").
- ReportPath: Path for the output report file.
- OU: Organizational Unit to search for user accounts.

## Example

```
$OU = "OU=TestComputers,DC=example,DC=com"
$ReportPath = "C:\temp\test.txt"
Remove-ADStaleComputers -GetLastLoggedIn Yes -DeleteStaleAccounts Yes -GenerateReport Yes -ReportPath $ReportPath -OU $OU -Verbose
```


## Installation

Clone the repository:

git clone https://github.com/Limitspassed/ADStaleAccounts.git

Import the module in PowerShell:

Import-Module "C:\path\to\ADStaleAccounts"

## Requirements

- PowerShell 5.1 or later
- Active Directory module for PowerShell

## License
This project is licensed under the MIT License - see the LICENSE file for details.