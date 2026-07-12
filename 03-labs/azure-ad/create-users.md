# Creating a new user in Azure AD - Add user accounts

Add individual user account through the Azure CLI.
```bash
# create a new user using Azure CLI
az ad user create
```

Add individual user account through the Azure PowerShell.
```PowerShell
# create a new user using Azure PowerShell
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
PowerShell will return the new user object you just created and show the ObjectId:

```PowerShell
ObjectId                             DisplayName UserPrincipalName                 UserType
--------                             ----------- -----------------                 --------
f36634c8-8a93-4909-9248-0845548bc515 New User    NewUser32@drumkit.onmicrosoft.com Member
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

## Example 1: Create a user

```PowerShell
$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile

$PasswordProfile.Password = "Password"

New-AzureADUser -DisplayName "New User" -PasswordProfile $PasswordProfile -UserPrincipalName "NewUser@contoso.com" -AccountEnabled $true -MailNickName "Newuser"

ObjectId                             DisplayName UserPrincipalName               UserType
--------                             ----------- -----------------               --------
5e8b0f4d-2cd4-4e17-9467-b0f6a5c0c4d0 New user    NewUser@contoso.com             Member
```
This command creates a new user.

Note: If you want to provide a value for an extension attribute when creating a new user, you must provide a parameter of the type System.Collections.Generic.Dictionary. The below example shows how to do this.

## Example 2: Create a user and set an extension attribute value

```PowerShell
$extension = New-Object "System.Collections.Generic.Dictionary``2[System.String,System.String]"
$extension.Add("extension_954520ceef9548acb415647bf957468d_ShoeSize","10")
$extension

Key                                                 Value
---                                                 -----
extension_954520ceef9548acb415647bf957468d_ShoeSize 10

New-AzureADUser -DisplayName "NewUser" -PasswordProfile $PasswordProfile -UserPrincipalName "NewUser@Contoso.com" -AccountEnabled $true -MailNickName "NewUser" -ExtensionProperty $extension

ObjectId                             DisplayName UserPrincipalName                 UserType
--------                             ----------- -----------------                 --------
5e8b0f4d-2cd4-4e17-9467-b0f6a5c0c4d0 NewUser     NewUser@Contoso.com               Member
```

In the first step we create a new object called "$extension" with object type "System.Collections.Generic.Dictionary". In the next step we add the extensionattribute 's name and value to the new object, and we display the object to see that we indeed created the correct object to serve as a parameter for the New-AzureADUser cmdlet. In the last step we create the new user and set the extension attribute value.

https://docs.microsoft.com/en-us/powershell/module/azuread/new-azureaduser?WT.mc_id=thomasmaurer-blog-thmaure&view=azureadps-2.0


## Delete user accounts

You can also delete user accounts through the Azure portal, Azure PowerShell, or the Azure CLI. In PowerShell, use the cmdlet ```Remove-AzureADUser```. In the Azure CLI, use the cmdlet ```az ad user delete```.

When you delete a user, the account remains in a suspended state for 30 days. During that 30-day window, the user account can be restored.














