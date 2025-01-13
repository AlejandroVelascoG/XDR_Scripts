# PowerShell script to test PVolume Shadow Copy Deletion detection rule

# Start a new PowerShell process (simulate what ElasticDefend is monitoring)
$process = Start-Process "powershell.exe" -ArgumentList "-Command" -PassThru

# Use Get-WmiObject to list Shadow Copies and then delete them
Get-WmiObject -Class Win32_ShadowCopy | ForEach-Object {
    $_.Delete()  # Delete each shadow copy found
}

# Alternatively, use Get-CimInstance and remove shadow copies using Remove-CimInstance
Get-CimInstance -ClassName Win32_ShadowCopy | ForEach-Object {
    Remove-CimInstance -InputObject $_  # Remove each shadow copy found
}

# Optionally, print some confirmation messages
Write-Host "Test complete: Shadow copies should have been deleted."
