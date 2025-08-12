# ========================
# Upload imgs folders to S3
# ========================

$bucketName = "peak-bagging-website-static"
$uploads = @() # Track uploads for summary

# Find all imgs directories recursively under content/posts
$imgsDirs = Get-ChildItem -Path "content/posts" -Directory -Recurse |
    Where-Object { $_.Name -eq "imgs" }

foreach ($dir in $imgsDirs) {
    $files = Get-ChildItem -Path $dir.FullName -File -Recurse

    if ($files.Count -eq 0) {
        Write-Host "Skipping empty folder: $($dir.FullName)" -ForegroundColor Yellow
        continue
    }

    # Post folder name (e.g., black_peak)
    $postName = $dir.Parent.Name

    # Build S3 path
    $s3Path = "s3://$bucketName/$postName/"

    Write-Host "Uploading $($dir.FullName) to $s3Path ..." -ForegroundColor Cyan

    # Upload recursively
    aws s3 cp $dir.FullName $s3Path --recursive | Out-Null

    # Track in summary
    $uploads += [PSCustomObject]@{
        Post       = $postName
        LocalPath  = $dir.FullName
        S3Path     = $s3Path
        FileCount  = $files.Count
    }
}

# Summary output
if ($uploads.Count -gt 0) {
    Write-Host "`nUpload Summary:" -ForegroundColor Green
    $uploads | Format-Table -AutoSize
} else {
    Write-Host "`nNo imgs folders with files found to upload." -ForegroundColor Red
}
