# Importing necessary cryptographic namespaces
Add-Type -TypeDefinition @"
using System;
using System.Security.Cryptography;
using System.Text;
"@

# Function to encrypt and decrypt a string using AES encryption
function Test-AESCryptography {
    param (
        [string]$plainText,
        [string]$key,
        [string]$iv
    )

    # Convert key and IV to byte arrays
    $keyBytes = [System.Text.Encoding]::UTF8.GetBytes($key)
    $ivBytes = [System.Text.Encoding]::UTF8.GetBytes($iv)

    # AES encryption setup
    $aes = [System.Security.Cryptography.AESManaged]::new()
    $aes.Key = $keyBytes
    $aes.IV = $ivBytes
    $aes.CipherMode = [System.Security.Cryptography.CipherMode]::CBC
    $aes.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7

    # Create Encryptor and Decryptor
    $encryptor = $aes.CreateEncryptor()
    $decryptor = $aes.CreateDecryptor()

    # Encrypt the plain text
    $plainBytes = [System.Text.Encoding]::UTF8.GetBytes($plainText)
    $cipherText = $encryptor.TransformFinalBlock($plainBytes, 0, $plainBytes.Length)

    # Decrypt the cipher text
    $decryptedBytes = $decryptor.TransformFinalBlock($cipherText, 0, $cipherText.Length)
    $decryptedText = [System.Text.Encoding]::UTF8.GetString($decryptedBytes)

    # Return the encrypted and decrypted result
    return @{
        EncryptedText = [Convert]::ToBase64String($cipherText)
        DecryptedText = $decryptedText
    }
}

# Test data
$plainText = "SensitiveData"
$key = "1234567890123456"  # 16-byte key for AES
$iv = "6543210987654321"   # 16-byte IV

# Encrypt and decrypt the data
$result = Test-AESCryptography -plainText $plainText -key $key -iv $iv

# Output the results
Write-Host "Encrypted Text: $($result.EncryptedText)"
Write-Host "Decrypted Text: $($result.DecryptedText)"

