# PowerShell script to test encryption/decryption rule

# Load necessary cryptography namespaces
Add-Type -TypeDefinition @"
using System;
using System.Security.Cryptography;
using System.Text;

public class CryptoHelper {
    public static string Encrypt(string plainText, string key, string iv) {
        using (Aes aesAlg = Aes.Create()) {
            aesAlg.Key = Encoding.UTF8.GetBytes(key);
            aesAlg.IV = Encoding.UTF8.GetBytes(iv);
            ICryptoTransform encryptor = aesAlg.CreateEncryptor(aesAlg.Key, aesAlg.IV);
            
            using (System.IO.MemoryStream msEncrypt = new System.IO.MemoryStream()) {
                using (CryptoStream csEncrypt = new CryptoStream(msEncrypt, encryptor, CryptoStreamMode.Write)) {
                    using (System.IO.StreamWriter swEncrypt = new System.IO.StreamWriter(csEncrypt)) {
                        swEncrypt.Write(plainText);
                    }
                }
                return Convert.ToBase64String(msEncrypt.ToArray());
            }
        }
    }

    public static string Decrypt(string cipherText, string key, string iv) {
        using (Aes aesAlg = Aes.Create()) {
            aesAlg.Key = Encoding.UTF8.GetBytes(key);
            aesAlg.IV = Encoding.UTF8.GetBytes(iv);
            ICryptoTransform decryptor = aesAlg.CreateDecryptor(aesAlg.Key, aesAlg.IV);
            
            using (System.IO.MemoryStream msDecrypt = new System.IO.MemoryStream(Convert.FromBase64String(cipherText))) {
                using (CryptoStream csDecrypt = new CryptoStream(msDecrypt, decryptor, CryptoStreamMode.Read)) {
                    using (System.IO.StreamReader srDecrypt = new System.IO.StreamReader(csDecrypt)) {
                        return srDecrypt.ReadToEnd();
                    }
                }
            }
        }
    }
}
"@ -Language CSharp

# Test encryption and decryption
$key = "1234567890123456"  # 16-byte key for AES
$iv = "1234567890123456"   # 16-byte IV for AES
$plainText = "This is a secret message."

# Encrypt the message
$encryptedText = [CryptoHelper]::Encrypt($plainText, $key, $iv)
Write-Host "Encrypted: $encryptedText"

# Decrypt the message
$decryptedText = [CryptoHelper]::Decrypt($encryptedText, $key, $iv)
Write-Host "Decrypted: $decryptedText"

# Additional code to invoke CreateEncryptor and CreateDecryptor
$aes = [System.Security.Cryptography.AesManaged]::new()
$encryptor = $aes.CreateEncryptor($aes.Key, $aes.IV)
$decryptor = $aes.CreateDecryptor($aes.Key, $aes.IV)
Write-Host "Encryptor and Decryptor created."
