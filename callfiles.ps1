# Description: This script clones a GitHub repository and executes a PowerShell script from it.
# REPO:
$url = "https://github.com/V1lTh/Windows-Comprehensive-Security-Policy-Automation/archive/refs/heads/main.zip"

function Save-GitHubRepository
{
    $path = "$HOME\Desktop"
    $output = "$path\MinClara_($(Get-Date -Format 'yyyy''-''MM''-''dd''-''HH''-''mm')).zip"
    $start_time = Get-Date
    invoke-webrequest -Uri $url -OutFile $output
    Expand-Archive $output .\ -Force
    Remove-Item $output -Force
    Write-Host "Time taken: $((Get-Date).Subtract($start_time).TotalSeconds) second(s)" 
}
Save-GitHubRepository
try {
    $script_path = "$path\Windows-Comprehensive-Security-Policy-Automation-main\SetPolicyWindows\Client\MinClara\clara100.ps1"
    $script_folder = "$path\Windows-Comprehensive-Security-Policy-Automation-main\SetPolicyWindows\Client\MinClara\"
    if (Test-Path $script_path) {
        Set-Location $script_folder
        & $script_path
    } else {
        Write-Host "Script not found at path: $script_path"
    }
}
catch {
    Write-Host "An error occurred: $_"
}