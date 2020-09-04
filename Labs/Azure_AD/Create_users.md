# Add user accounts

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

## Delete user accounts

You can also delete user accounts through the Azure portal, Azure PowerShell, or the Azure CLI. In PowerShell, use the cmdlet ```Remove-AzureADUser```. In the Azure CLI, use the cmdlet ```az ad user delete```.

When you delete a user, the account remains in a suspended state for 30 days. During that 30-day window, the user account can be restored.














