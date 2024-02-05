function CalcChecksumOfFiles {

    param (
        [Parameter(Mandatory=$true)]
        [array]$files
    )

    # Write-Host $files.Length

    # 配列 $files をソート
    $sortedFiles = $files | Sort-Object

    # チェックサムを格納する変数を初期化
    $total = ""

    # 各ファイルに対して処理を行う
    foreach ($file in $sortedFiles) {
        # ファイルが存在するか確認
        if (Test-Path $file) {
            # ファイルが存在する場合、チェックサムを取得
            $checksum = Get-FileHash -Path $file -Algorithm SHA256

            # チェックサムを $total に連結
            $total += $checksum.Hash
        }
    }

    # # 最終的なチェックサムの値を出力
    # Write-Host "Initial checksum: " $total

    # $total のチェックサムを計算
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($total)
    $totalChecksum = Get-FileHash -InputStream ([System.IO.MemoryStream]::new($bytes))

    # # $total のチェックサムを出力
    # Write-Host "Final checksum: " $totalChecksum.Hash

    return $totalChecksum.Hash
}