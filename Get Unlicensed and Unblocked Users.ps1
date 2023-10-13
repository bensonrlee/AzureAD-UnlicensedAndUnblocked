# Install the AzureAD module if not already installed
# Install-Module -Name AzureAD -Force -AllowClobber

# Import the AzureAD module
Import-Module AzureAD

# Connect to Azure AD
Connect-AzureAD

# Fetch all users
$allUsers = Get-AzureADUser -All $true

# Filter unlicensed, not sign-in blocked users, and exclude external users
$unlicensedUsers = $allUsers | Where-Object {
    # Check if user is unlicensed
    (-not $_.AssignedLicenses) -or ($_.AssignedLicenses.Count -eq 0) -and 
    # Check if user is not sign-in blocked
    ($_.AccountEnabled -eq $true) -and 
    # Exclude external users
    ($_.UserPrincipalName -notlike "*#EXT#*")
}

# Display the filtered users
$unlicensedUsers | Format-Table UserPrincipalName, DisplayName

# Disconnect from Azure AD
Disconnect-AzureAD
