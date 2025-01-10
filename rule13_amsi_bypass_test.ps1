# PowerShell script to test AMSI bypass detection
# This script simulates a potential AMSI bypass technique

# Displaying a message
Write-Host "Testing AMSI bypass via PowerShell..."

# Example AMSI bypass using a known function
# This could trigger detection of the 'Invoke-AmsiBypass' string or related patterns
$amsiBypass = @"
function Invoke-AmsiBypass {
    $amsi = [System.Management.Automation.AmsiUtils]::GetAmsiContext()
    $amsi.GetType().GetMethod('Uninitialize').Invoke($amsi, @())
}
Invoke-AmsiBypass
"@

# Execute the AMSI bypass function
Invoke-Expression $amsiBypass

# Another example using VirtualProtect and Marshal.Copy (common bypass technique)
$code = @"
Add-Type @"
using System;
using System.Runtime.InteropServices;

public class AMSI {
    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern IntPtr VirtualAlloc(IntPtr lpAddress, UIntPtr dwSize, uint flAllocationType, uint flProtect);
    
    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern bool VirtualProtect(IntPtr lpAddress, uint dwSize, uint flNewProtect, out uint lpflOldProtect);
    
    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern bool VirtualFree(IntPtr lpAddress, uint dwSize, uint dwFreeType);
}
"@
"@

Add-Type -TypeDefinition $code -Language CSharp

# Using Marshal to copy data and manipulate memory (can be used for AMSI bypass)
$pointer = [System.IntPtr]::Zero
$size = [System.UInt32]::MaxValue
[AMSI]::VirtualProtect($pointer, $size, 0x40, [ref]$null)  # Attempt to alter memory protection

Write-Host "Test complete. Check for alerts in Elastic Defend."
