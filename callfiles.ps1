# Description: This script clones a GitHub repository and executes a PowerShell script from it.
# REPO:
$url = "https://github.com/V1lTh/Windows-Comprehensive-Security-Policy-Automation/archive/refs/heads/main.zip"
$path = "$HOME\Desktop"
$output = "$path\MinClara_($(Get-Date -Format 'yyyy''-''MM''-''dd''-''HH''-''mm')).zip"
function Save-GitHubRepository
{
    $start_time = Get-Date
    invoke-webrequest -Uri $url -OutFile $output
    Expand-Archive $output $path -Force
    Remove-Item $output -Force
    Write-Host "Time taken: $((Get-Date).Subtract($start_time).TotalSeconds) second(s)" 
}
try {
    Save-GitHubRepository
    $script_path = "$path\Windows-Comprehensive-Security-Policy-Automation-main\SetPolicyWindows\Client\MinClara\runASadmin.bat"
    $path_folder = "$path\Windows-Comprehensive-Security-Policy-Automation-main\"
    if (Test-Path $script_path) {
        Start-Process -FilePath $script_path -Verb RunAs
    } else {
        Write-Host "Script not found at path: $script_path"
    }
}
catch {
    Write-Host "An error occurred: $_"
}
finally {
    if (Test-Path $output) {
    Remove-Item $path_folder -Force -Recurse
    shutdown /r /t 0
    }
}
