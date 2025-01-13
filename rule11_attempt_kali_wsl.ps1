# PowerShell script to test "Attempt to install Kali Linux via WSL" rule

# Simulate running wsl.exe with Kali Linux installation arguments
Start-Process "wsl.exe" -ArgumentList "--install", "-d", "kali-linux"  # This matches the wsl.exe args in the rule

# Simulate running kali.exe from the expected WindowsApps path
$kaliPath = "$env:USERPROFILE\AppData\Local\Microsoft\WindowsApps\kali.exe"
Start-Process $kaliPath  # This simulates the Kali executable being launched from the WindowsApps directory

# Alternatively, you can simulate launching kali.exe from another expected path
$anotherKaliPath = "$env:USERPROFILE\AppData\Local\packages\kalilinux_*\LocalState\kali.exe"
Start-Process $anotherKaliPath  # This simulates the Kali executable being launched from the LocalState folder

Write-Host "Test complete: Kali Linux installation process should have been simulated."
