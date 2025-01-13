# PowerShell script to simulate Microsoft Exchange Worker spawning suspicious processes

# First, simulate the environment by starting the IIS worker process (w3wp.exe)
Start-Process "w3wp.exe" -ArgumentList "MSExchange*AppPool"

# Now, simulate spawning a suspicious process from the parent process (w3wp.exe)
# In this case, we'll launch powershell.exe, which is the suspicious process to test

Start-Process "powershell.exe" -ArgumentList "-Command", "Write-Host 'This is a test of a suspicious process spawn.'"

# Optionally, log to confirm the child process has been launched
Write-Host "Suspicious process (powershell.exe) spawned under w3wp.exe."
