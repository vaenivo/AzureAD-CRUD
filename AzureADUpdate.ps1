# Retrieve the token from environment variable
$token = $env:AZURE_AD_TOKEN

if (-not $token) {
    Write-Error "Token is not set in the environment variable. Please set the AZURE_AD_TOKEN environment variable and try again."
    exit
}

# Prompt for the UserPrincipalName to know which user to update
$userPrincipalName = Read-Host "Enter the UserPrincipalName of the user you wish to update"

# Prompt for user update information
$jobTitle = Read-Host "Enter the updated job title"
$mobilePhone = Read-Host "Enter the updated mobile phone number"
$preferredLanguage = Read-Host "Enter the updated preferred language (e.g., 'en-US')"
$officeLocation = Read-Host "Enter the updated office location"

# Azure AD User update endpoint specific to the provided userPrincipalName
$uri = "https://graph.microsoft.com/v1.0/users/$userPrincipalName"

# Prepare the headers with the token
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

# User update information
$userUpdateInfo = @{
    jobTitle          = $jobTitle
    mobilePhone       = $mobilePhone
    preferredLanguage = $preferredLanguage
    officeLocation    = $officeLocation
}

# Convert user update information to JSON
$body = $userUpdateInfo | ConvertTo-Json

try {
    # Make the API call to update the user
    Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body
    Write-Output "User updated successfully."
}
catch {
    Write-Error "Failed to update user"
    Write-Error $_.Exception.Message
    Write-Error "Detailed Response: $($_.Exception.Response.Content.ReadAsStringAsync().Result)"
}
