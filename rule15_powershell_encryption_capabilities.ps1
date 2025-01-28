# This script contains cryptographic operations that should trigger the ElasticDefend rule
# Ensure you're running this as a regular user (not SYSTEM)

# Create AES cryptographic object
$algorithm = New-Object System.Security.Cryptography.AESManaged

# Configure cipher parameters
$algorithm.Mode = [System.Security.Cryptography.CipherMode]::CBC
$algorithm.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7

# Generate encryption components
$key = [System.Convert]::FromBase64String("k6PrY5+8Tm9H4W1dDgpxsxqZJol1mC0b3EeKjB2QnVw=")
$iv = [System.Convert]::FromBase64String("UXZtRWFoTDlHY1FKdkhjYg==")

# Create encryptor (matches rule pattern)
$encryptor = $algorithm.CreateEncryptor($key, $iv)

# Simple encryption demonstration
$original = "Test payload for encryption"
$memoryStream = New-Object System.IO.MemoryStream
$cryptoStream = New-Object System.Security.Cryptography.CryptoStream(
    $memoryStream,
    $encryptor,
    [System.Security.Cryptography.CryptoStreamMode]::Write
)
$streamWriter = New-Object System.IO.StreamWriter($cryptoStream)
$streamWriter.Write($original)
$streamWriter.Close()

Write-Host "Test encryption completed successfully"


