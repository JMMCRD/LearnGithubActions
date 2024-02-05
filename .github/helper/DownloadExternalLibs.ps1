$dir_name_downloads = "downloads"
$dir_name_externals = "Externals"

# ダウンロード先フォルダを作成
New-Item -ItemType Directory -Path $dir_name_downloads -Force
# Externals フォルダを作成
New-Item -ItemType Directory -Path $dir_name_externals -Force

$list_libs=(
@{dir="qhull";url="https://github.com/qhull/qhull/archive/refs/tags/2020.2.zip";},
@{dir="boost";url="https://github.com/boostorg/boost/releases/download/boost-1.82.0/boost-1.82.0.zip";},
@{dir="Eigen3";url="https://gitlab.com/libeigen/eigen/-/archive/3.4.0/eigen-3.4.0.zip";},
@{dir="flann";url="https://github.com/flann-lib/flann/archive/refs/tags/1.9.1.zip";},
@{dir="zlib";url="https://github.com/madler/zlib/releases/download/v1.3/zlib13.zip";},
@{dir="bzip2";url="https://sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz";},
@{dir="vtk";url="https://github.com/Kitware/VTK/archive/refs/tags/v9.2.6.zip"},
@{dir="pcl";url="https://github.com/PointCloudLibrary/pcl/releases/download/pcl-1.13.1/source.zip"},
@{dir="open3d";url="https://github.com/isl-org/Open3D/archive/refs/tags/v0.17.0.zip"}
)

# 展開一時フォルダ名
$dir_name_tmp = $dir_name_downloads+"/tmp"

Foreach($item in $list_libs){
    $url = $item.url
    $dir = $item.dir
    $list_split_url = $url -split '/'
    $filename = $list_split_url[-1]

    $outputPath = $dir_name_downloads + "/" + $filename
    Write-Output "====================="
    Write-Output $dir
    Write-Output $url
    Write-Output $outputPath
    Write-Output "---"

    if (-Not (Test-Path -Path $outputPath)) {
        # ダウンロード
        Invoke-WebRequest -Uri $url -OutFile $outputPath
    } else {
        Write-Output "Using local copy of $outputPath"
    }

    # if ($outputPath -match "\.tar\.gz$") {
    #     if (!(Test-Path -Path $dir_name_tmp)) {
    #         New-Item -ItemType directory -Path $dir_name_tmp
    #     }
    #     tar -xvzf $outputPath -C $dir_name_tmp
    # } elseif ($outputPath -match "\.zip$"){
    #     # ZIPファイルを一時フォルダに展開
    #     Expand-Archive -Path $outputPath -DestinationPath $dir_name_tmp -Force
    # } else {
    #     Write-Output "$outputPath is not an archive file"
    #     continue
    # }
    # $extractedItems = Get-ChildItem -Path $dir_name_tmp
    # Write-Output "extractedItems = $extractedItems"
    # Write-Output ($extractedItems.Count)
    
    # # 展開後のフォルダ名を確認して、必要に応じてリネームする
    # $extractedFolders = $extractedItems | Where-Object { $_.PSIsContainer }
    # Write-Output ($extractedFolders.Count)
    # $destdir = (Join-Path -Path $dir_name_externals -ChildPath $dir)
    # if (($extractedItems.Count -eq 1) -And ($extractedFolders.Count -eq 1)) {
    #     Move-Item -Path (Join-Path -Path $dir_name_tmp -ChildPath $extractedFolders.Name) -Destination ($destdir)
    # } else {
    #     $destdir = ($destdir)
    #     New-Item -ItemType directory -Path $destdir -Force
    #     foreach ($item2 in $extractedItems) {
    #         Write-Output "item2 = $item2"
    #         Move-Item -Path (Join-Path -Path $dir_name_tmp -ChildPath $item2) -Destination $destdir
    #     }
    # }
    # # 後片付け: tmp フォルダの削除
    # Remove-Item -path $dir_name_tmp -recurse -force

}

