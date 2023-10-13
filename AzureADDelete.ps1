# Ensure the token is available
if (-not $env:AZURE_AD_TOKEN) {
    Write-Error "Token is not set in the environment variable. Please set the AZURE_AD_TOKEN environment variable and try again."
    exit
}

# Prompt for the user's UserPrincipalName
$userPrincipalName = Read-Host "Enter the UserPrincipalName of the user you wish to delete"

# Confirm delete action
$confirmation = Read-Host "Are you sure you want to delete $userPrincipalName? (Yes/No)"
if ($confirmation -ne 'Yes') {
    Write-Output "Delete action canceled."
    exit
}

# Construct the URI for the user
$uri = "https://graph.microsoft.com/v1.0/users/$userPrincipalName"

# Prepare the headers with the token
$headers = @{
    "Authorization" = "Bearer $($env:AZURE_AD_TOKEN)"
    "Content-Type"  = "application/json"
}

try {
    # Make the API call to delete the user
    Invoke-RestMethod -Uri $uri -Method Delete -Headers $headers
    Write-Output "User $userPrincipalName deleted successfully."
} catch {
    Write-Error "Failed to delete user"
    Write-Error $_.Exception.Message

    # Check for token-related issues
    if ($_.Exception.Response.StatusCode -eq 401) {
        Write-Error "The token might be invalid or has expired. Please refresh your token and try again."
    }
}
