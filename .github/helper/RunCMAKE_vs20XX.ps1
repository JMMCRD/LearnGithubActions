param (
    [Parameter(Mandatory=$true)]
    [string]$vsyear,
    [Parameter(Mandatory=$true)]
    [string]$options
)

Write-Host "vsyear" $vsyear 
Write-Host "options" $options

$pathVsDevCmd = ""
if ($vsyear -eq "2022") {
    $pathVsDevCmd = 'C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\Tools\VsDevCmd.bat'
} elseif ($vsyear -eq "2019") {
    $pathVsDevCmd = 'C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\Common7\Tools\VsDevCmd.bat'
}
if (-Not (Test-Path $pathVsDevCmd) ) {
    Write-Host "File not found: $pathVsDevCmd"
    $vspath = vswhere.exe -latest -property installationPath
    $pathVsDevCmd = Join-Path -Path $vspath  -ChildPath "Common7\Tools\vsdevcmd.bat"
    if (-Not (Test-Path $pathVsDevCmd) ) {
        Write-Host "vsdevcmd.bat not found"
        return
    }
}
Write-Host "File found: $pathVsDevCmd"
Write-Host "Run VsDevCmd"
# VSDevCmd.bat を実行し、環境変数を取得
$envVars = cmd /c "`"$pathVsDevCmd`" && set"
# 取得した環境変数を PowerShell セッションにインポート
foreach ($line in $envVars) {
    Write-Host $line
    if ($line -match "=") {
        $v = $line.split("=")
        set-item -force -path "ENV:\$($v[0])" -value "$($v[1])"
    }
}
Write-Host "ENV set OK"
Write-Host "Start CMAKE"
Start-Process -FilePath "cmake" -ArgumentList $options -Wait -NoNewWindow
Write-Host "End CMAKE"
