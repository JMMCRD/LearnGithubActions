param (
    [Parameter(Mandatory=$true)]
    [string]$cuda,

    [Parameter(Mandatory=$true)]
    [string]$download
)

$path_download = $download
$cuda_ver=$cuda
$url = ""
$cuda_ver_short = ""
$cuda_ver_major=""
$cuda_ver_minor=""
$CUDA_KNOWN_URLS = @{
    "11.6.2" = "https://developer.download.nvidia.com/compute/cuda/11.6.2/network_installers/cuda_11.6.2_windows_network.exe";
    "11.7.1" = "https://developer.download.nvidia.com/compute/cuda/11.7.1/network_installers/cuda_11.7.1_windows_network.exe";
    "11.8.0" = "https://developer.download.nvidia.com/compute/cuda/11.8.0/network_installers/cuda_11.8.0_windows_network.exe";
    "12.0.1" = "https://developer.download.nvidia.com/compute/cuda/12.0.1/network_installers/cuda_12.0.1_windows_network.exe";
    "12.1.1" = "https://developer.download.nvidia.com/compute/cuda/12.1.1/network_installers/cuda_12.1.1_windows_network.exe";
    "12.2.2" = "https://developer.download.nvidia.com/compute/cuda/12.2.2/network_installers/cuda_12.2.2_windows_network.exe";
    "12.3.2" = "https://developer.download.nvidia.com/compute/cuda/12.3.2/network_installers/cuda_12.3.2_windows_network.exe";
}

if ($CUDA_KNOWN_URLS.ContainsKey($cuda_ver)){
    $url = $CUDA_KNOWN_URLS[$cuda_ver]
    $list_split_ver = $cuda_ver.Split(".")
    $cuda_ver_major = $list_split_ver[0]
    $cuda_ver_minor = $list_split_ver[1]
    $cuda_ver_short = $cuda_ver_major+"."+$cuda_ver_minor
}

$list_split_url = $url.Split('/')
$filename = $list_split_url[-1]
$dir_name_dl = $path_download
$outputPath = $dir_name_dl + "/" + $filename
if (!(Test-Path -Path $dir_name_dl)) {
  New-Item -ItemType directory -Path $dir_name_dl
}
Invoke-WebRequest -Uri $url -OutFile $outputPath
if (!(Test-Path -Path $outputPath -PathType leaf)) {
    Write-Output "File not found: "
    Write-Output $outputPath
}

$list_install_option=@(
    "cuda_profiler_api_"+$cuda_ver_short,
    "cudart_"+$cuda_ver_short,
    "cuobjdump_"+$cuda_ver_short,
    "cupti_"+$cuda_ver_short,
    "cuxxfilt_"+$cuda_ver_short,
    # "demo_suite_"+$cuda_ver_short,
    # "documentation_"+$cuda_ver_short,
    "memcheck_"+$cuda_ver_short,
    "nvcc_"+$cuda_ver_short,
    "nvdisasm_"+$cuda_ver_short,
    "nvml_dev_"+$cuda_ver_short,
    "nvprof_"+$cuda_ver_short,
    "nvprune_"+$cuda_ver_short,
    "nvrtc_"+$cuda_ver_short,
    "nvrtc_dev_"+$cuda_ver_short,
    "nvtx_"+$cuda_ver_short,
    # "visual_profiler_"+$cuda_ver_short,
    "sanitizer_"+$cuda_ver_short,
    "thrust_"+$cuda_ver_short,
    "cublas_"+$cuda_ver_short,
    "cublas_dev_"+$cuda_ver_short,
    "cufft_"+$cuda_ver_short,
    "cufft_dev_"+$cuda_ver_short,
    "curand_"+$cuda_ver_short,
    "curand_dev_"+$cuda_ver_short,
    "cusolver_"+$cuda_ver_short,
    "cusolver_dev_"+$cuda_ver_short,
    "cusparse_"+$cuda_ver_short,
    "cusparse_dev_"+$cuda_ver_short,
    "npp_"+$cuda_ver_short,
    "npp_dev_"+$cuda_ver_short,
    "nvjpeg_"+$cuda_ver_short,
    "nvjpeg_dev_"+$cuda_ver_short,
    # "nsight_compute_"+$cuda_ver_short,
    # "nsight_nvtx_"+$cuda_ver_short,
    # "nsight_systems_"+$cuda_ver_short,
    # "nsight_vse_"+$cuda_ver_short,
    "visual_studio_integration_"+$cuda_ver_short
    # "occupancy_calculator_"+$cuda_ver_short,
)

$option_string = [string]::Join(" ", $list_install_option)
$option_string = "-s "+ $option_string
Write-Host $list_install_option

$process = Start-Process -FilePath $outputPath -ArgumentList $option_string -Wait -PassThru
if ($process.ExitCode -ne 0) {
    Write-Output "app.exe exited with code $($process.ExitCode)"
}
if (!$?) {
    Write-Output "Error: CUDA installer reported error. $($LASTEXITCODE)"
    exit 1 
}
Write-Host "Phase 1: CUDA_PATH = $($CUDA_PATH)"
# CUDA のインストールパス
$CUDA_PATH = "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v$($cuda_ver_major).$($cuda_ver_minor)"
Write-Host "Phase 2: CUDA_PATH = $($CUDA_PATH)"
$env:CUDA_PATH="$($CUDA_PATH)"

$path_nvcc = "$($CUDA_PATH)\bin\nvcc.exe"
Write-Output "path_nvcc: " $path_nvcc
# Start-Process -FilePath $path_nvcc -ArgumentList "-V" -NoNewWindow -Wait

$env:envname_CUDA_PATH_VX_Y = "CUDA_PATH_V$($cuda_ver_major)_$($cuda_ver_minor)" 
Write-Output "env:envname_CUDA_PATH_VX_Y: $env:envname_CUDA_PATH_VX_Y"

$env:CUDA_VER_0="$($cuda_ver_major)"
$env:CUDA_VER_1="$($cuda_ver_minor)"


