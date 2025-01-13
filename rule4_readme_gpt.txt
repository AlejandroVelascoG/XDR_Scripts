To test the `ElasticDefend` rule for "PVolume Shadow Copy Deletion via PowerShell," the script needs to include the following key elements based on the rule query:

1. The PowerShell process name should be one of `"powershell.exe"`, `"pwsh.exe"`, or `"powershell_ise.exe"`.
2. The script should use commands that interact with Windows Management Instrumentation (WMI) or CIM (Common Information Model), particularly methods related to `Win32_ShadowCopy`.
3. The script should invoke a deletion method, such as `Delete()`, `Remove-WmiObject`, or `Remove-CimInstance`.

### Example PowerShell Script for Testing:

```powershell
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
```

### Explanation:

1. **Process Name and Arguments**: This script runs in the `powershell.exe` process (which matches one of the process names in the query), and uses the `Get-WmiObject` and `Get-CimInstance` cmdlets, both of which match the query's requirement for WMI/CIM interactions.
2. **Shadow Copy Deletion**:
    - `Get-WmiObject -Class Win32_ShadowCopy | ForEach-Object { $_.Delete() }`: This part lists the shadow copies and deletes them by calling the `Delete()` method.
    - `Get-CimInstance -ClassName Win32_ShadowCopy | ForEach-Object { Remove-CimInstance -InputObject $_ }`: Similarly, this part uses `Get-CimInstance` to list shadow copies and deletes them using `Remove-CimInstance`.
3. **Rule Matching**:
    - The rule looks for PowerShell processes (`powershell.exe`, `pwsh.exe`, `powershell_ise.exe`) with arguments that include `Get-WmiObject`, `gwmi`, `Get-CimInstance`, or `gcim`, specifically when shadow copy deletion is invoked (via `.Delete()` or `Remove-CimInstance`).

### Additional Notes:

- **Key Matching Elements**: The query looks for arguments that include both `*Win32_ShadowCopy*` and deletion-related actions (`*.Delete()*`, `*Remove-WmiObject*`, etc.), which this script fulfills.
- **Testing the Rule**: When this script is executed, the `ElasticDefend` rule should trigger because it detects PowerShell processes interacting with `Win32_ShadowCopy` and deleting them, which matches the criteria in the query.
- **Environment Considerations**: Ensure that the system running this script has Shadow Copies available and that you have the necessary permissions to delete them. Otherwise, the `Delete()` method might not succeed.

### Running the Test:
1. Run this script in a PowerShell session on a Windows machine where `ElasticDefend` is active.
2. Observe whether `ElasticDefend` triggers an alert based on the rule query, which should match the PowerShell process performing shadow copy deletions.

This script should effectively test the rule for detecting PowerShell-based shadow copy deletions.
