param (
    [Parameter(Position=0, Mandatory=$false)]
    [string]$PostFolderName
)

$bucketName = "peak-bagging-website-static"

function Upload-FolderImgs {
    param (
        [string]$PostName
    )

    $localImgsPath = Join-Path -Path "content/posts" -ChildPath "$PostName\imgs"

    if (-Not (Test-Path $localImgsPath)) {
        Write-Host "Folder '$localImgsPath' does not exist." -ForegroundColor Yellow
        return
    }

    $files = Get-ChildItem -Path $localImgsPath -File -Recurse

    if ($files.Count -eq 0) {
        Write-Host "No files found in '$localImgsPath' to upload." -ForegroundColor Yellow
        return
    }

    $s3Path = "s3://$bucketName/$PostName/"

    Write-Host "Uploading $localImgsPath to $s3Path ..." -ForegroundColor Cyan
    aws s3 cp $localImgsPath $s3Path --recursive
    Write-Host "Uploaded $($files.Count) files for post '$PostName'." -ForegroundColor Green
}

if ($PostFolderName) {
    # Upload only the specified post folder
    Upload-FolderImgs -PostName $PostFolderName
} else {
    # Upload all imgs folders under content/posts
    $imgsDirs = Get-ChildItem -Path "content/posts" -Directory -Recurse | Where-Object { $_.Name -eq "imgs" }

    if ($imgsDirs.Count -eq 0) {
        Write-Host "No imgs folders found under content/posts." -ForegroundColor Red
        exit 0
    }

    foreach ($dir in $imgsDirs) {
        $postName = $dir.Parent.Name
        Upload-FolderImgs -PostName $postName
    }
}
