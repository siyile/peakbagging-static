# Hippo Hamster Peakbagging Static Web

## New Post

```
hugo new content content/posts/alpine_lake_wilderness/cannon_mountain/index.md
```

## Build and Server
```
hugo server -D
```

## Upload images to S3
Image need to be upload to S3.  
**Upload all**
```
.\upload-imgs-to-s3.ps1
```
**Upload only a single post folder**
```
.\upload-imgs-to-s3.ps1 black_peak
.\upload-imgs-to-s3.ps1 alpine_lake_wilderness/cannon_mountain
```
