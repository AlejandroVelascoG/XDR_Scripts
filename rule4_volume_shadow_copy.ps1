# PowerShell script to simulate Volume Shadow Copy Deletion and trigger ElasticDefend rule

# Define the function to delete Volume Shadow Copies
function Remove-ShadowCopy {
    try {
        # Get all shadow copies (Win32_ShadowCopy WMI class)
        $shadowCopies = Get-WmiObject -Class Win32_ShadowCopy

        # Check if there are any shadow copies
        if ($shadowCopies) {
            # Loop through each shadow copy and attempt to delete
            foreach ($shadowCopy in $shadowCopies) {
                Write-Host "Deleting shadow copy: $($shadowCopy.ID)"
                # Delete the shadow copy (using Remove-WmiObject to trigger the rule)
                $shadowCopy.Delete()
            }
        } else {
            Write-Host "No shadow copies found."
        }
    } catch {
        Write-Host "Error during shadow copy deletion: $_"
    }
}

# Call the function to remove shadow copies
Remove-ShadowCopy

# Alternative method to remove shadow copies using Get-CimInstance and Remove-CimInstance
function Remove-ShadowCopyCIM {
    try {
        # Get all shadow copies using Get-CimInstance (alternative to Get-WmiObject)
        $shadowCopiesCIM = Get-CimInstance -ClassName Win32_ShadowCopy

        # Check if there are any shadow copies
        if ($shadowCopiesCIM) {
            # Loop through each shadow copy and attempt to delete
            foreach ($shadowCopy in $shadowCopiesCIM) {
                Write-Host "Deleting shadow copy using CIM: $($shadowCopy.ID)"
                # Delete the shadow copy using Remove-CimInstance (alternative to Remove-WmiObject)
                Remove-CimInstance -InputObject $shadowCopy
            }
        } else {
            Write-Host "No shadow copies found using CIM."
        }
    } catch {
        Write-Host "Error during CIM-based shadow copy deletion: $_"
    }
}

# Call the function to remove shadow copies using CIM
Remove-ShadowCopyCIM

# Simulate error with invalid syntax (to simulate realistic behavior)
try {
    # This will produce a syntax error: misspelled function name
    gwmi Win32_ShadowCopy | Remove-WmiObject
} catch {
    Write-Host "Syntax error caught while trying to delete shadow copy: $_"
}

# Call the functions to ensure we trigger the rule
Write-Host "Testing Volume Shadow Copy Deletion complete."

