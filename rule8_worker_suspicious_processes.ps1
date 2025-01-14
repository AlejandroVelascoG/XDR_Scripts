# Simulating the environment where w3wp.exe is the parent process
# This script will spawn a PowerShell process as a child of w3wp.exe

# Simulate the parent process 'w3wp.exe' with the 'MSExchange*AppPool' argument
$w3wpProcess = Start-Process "w3wp.exe" -ArgumentList "MSExchangeAppPool" -PassThru

# Ensure the script simulates the spawning of a child process under 'w3wp.exe'
# This child process should be one of the listed suspicious processes (powershell.exe, cmd.exe, etc.)

# Start PowerShell (pwsh.exe) as the child process of w3wp.exe
$childProcess = Start-Process "pwsh.exe" -ArgumentList "-Command 'Write-Host ""Testing Exchange Worker Spawning Suspicious Processes""" -PassThru

# Sleep for a few seconds to ensure the processes have time to initialize
Start-Sleep -Seconds 3

# Output to indicate that the child process has been spawned by w3wp.exe
Write-Host "PowerShell child process spawned under w3wp.exe (MSExchangeAppPool)."

# End the parent process simulation (w3wp.exe)
$w3wpProcess.Kill()
