# ADStaleAccounts Module

## Overview

The `ADStaleAccounts` module provides PowerShell functions to manage Active Directory user accounts. It includes functionalities for creating test users and cleaning up stale accounts based on their last logon dates.

## Functions

### 1. Create-ADTestUsers

Creates a specified number of test user accounts in a designated Organizational Unit (OU) within Active Directory.

#### Parameters
- **OU**: The Organizational Unit where the test user accounts will be created.
- **Domain**: The domain for the User Principal Name (UPN).

#### Example

```
$OU = "OU=TestUsers,DC=example,DC=com"
$Domain = "example.com"
Create-ADTestUsers -OU $OU -Domain $Domain
```

### 2. Clean-ADStaleUsers

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
Clean-ADStaleUsers -GetLastLoggedIn Yes -DeleteStaleAccounts Yes -GenerateReport Yes -ReportPath $ReportPath -OU $OU -Verbose
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