# Creating a new user in Azure AD - Add user accounts

Add individual user account through the Azure CLI.
```bash
# create a new user CLI
az ad user create
```

Add individual user account through the Azure PowerShell.
```PowerShell
# create a new user PowerShell
New-AzureADUser
```

Example:
The cmdlet used is New-AzureADUser. This cmdlet has many parameters that you can use to decorate the new user object in Azure AD. In this example we'll only look at the mandatory parameters:

* **DisplayName** - contains the display name for the new user, in our example this is "Abby Brown"
* **MailNickName** - contains the email alias of the new user, we'll set it to "AbbyB"
* **UserPrincipalName** - contains the UserPrincipalName (UPN) of this user. The UPN is what the user will use when they sign in into Azure AD. The common structure is @, so for Abby Brown in Contoso.com, the UPN would be "AbbyB@contoso.com"
* **AccountEnabled** - this indicates whether the account is enabled for sign in. If you set it to $False, the user will not be able to use the account, but you can set it ti $True right now or do that later if you need to perform other configuration tasks for the new user, such as assigning licenses or applications.
* **PasswordProfile** - Specifies the user's password profile. Note that the parameter type for this parameter is "PasswordProfile". in order to pass a parameter of this type, you first need to create a variable in PowerShell with that type. We can do that with the New-Object cmdlet:

```powershell 
$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
```
Then you can proceed to set the value of the password in this variable:

```powershell 
$PasswordProfile.Password = "<Password>"
```

To create the user, call the New-AzureADUser cmdlet with the parameter values:

```powershell 
New-AzureADUser -AccountEnabled $True -DisplayName "Abby Brown" -PasswordProfile $PasswordProfile -MailNickName "AbbyB" -UserPrincipalName "AbbyB@contoso.com"
```

You can bulk create member users and guests accounts. The following example shows how to bulk invite guest users.

```PowerShell
$invitations = import-csv c:\bulkinvite\invitations.csv

$messageInfo = New-Object Microsoft.Open.MSGraph.Model.InvitedUserMessageInfo

$messageInfo.customizedMessageBody = "Hello. You are invited to the Contoso organization."

foreach ($email in $invitations)
   {New-AzureADMSInvitation `
      -InvitedUserEmailAddress $email.InvitedUserEmailAddress `
      -InvitedUserDisplayName $email.Name `
      -InviteRedirectUrl https://myapps.microsoft.com `
      -InvitedUserMessageInfo $messageInfo `
      -SendInvitationMessage $true
   }
```
You create the comma-separated values (CSV) file with the list of all the users you want to add. An invitation is sent to each user in that CSV file.

# New-AzureADUser

Creates an AD user.

```PowerShell
New-AzureADUser
   [-ExtensionProperty <System.Collections.Generic.Dictionary`2[System.String,System.String]>]
   -AccountEnabled <Boolean>
   [-City <String>]
   [-Country <String>]
   [-CreationType <String>]
   [-Department <String>]
   -DisplayName <String>
   [-FacsimileTelephoneNumber <String>]
   [-GivenName <String>]
   [-IsCompromised <Boolean>]
   [-ImmutableId <String>]
   [-JobTitle <String>]
   [-MailNickName <String>]
   [-Mobile <String>]
   [-OtherMails <System.Collections.Generic.List`1[System.String]>]
   [-PasswordPolicies <String>]
   -PasswordProfile <PasswordProfile>
   [-PhysicalDeliveryOfficeName <String>]
   [-PostalCode <String>]
   [-PreferredLanguage <String>]
   [-ShowInAddressList <Boolean>]
   [-SignInNames <System.Collections.Generic.List`1[Microsoft.Open.AzureAD.Model.SignInName]>]
   [-State <String>]
   [-StreetAddress <String>]
   [-Surname <String>]
   [-TelephoneNumber <String>]
   [-UsageLocation <String>]
   [-UserPrincipalName <String>]
   [-UserType <String>]
   [<CommonParameters>]
```

Example 1: Create a user

```PowerShell
$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile

$PasswordProfile.Password = "Password"

New-AzureADUser -DisplayName "New User" -PasswordProfile $PasswordProfile -UserPrincipalName "NewUser@contoso.com" -AccountEnabled $true -MailNickName "Newuser"

ObjectId                             DisplayName UserPrincipalName               UserType
--------                             ----------- -----------------               --------
5e8b0f4d-2cd4-4e17-9467-b0f6a5c0c4d0 New user    NewUser@contoso.com             Member
```








## Delete user accounts

You can also delete user accounts through the Azure portal, Azure PowerShell, or the Azure CLI. In PowerShell, use the cmdlet ```Remove-AzureADUser```. In the Azure CLI, use the cmdlet ```az ad user delete```.

When you delete a user, the account remains in a suspended state for 30 days. During that 30-day window, the user account can be restored.














