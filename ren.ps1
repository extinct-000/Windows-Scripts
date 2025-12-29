function Set-Comment {
    param(
        [string]$nam,
        [string]$com
    )

    $temp = "temp_$nam"

    ffmpeg -y -i "$nam" -c copy -metadata title="$com" "$temp"

    Remove-Item "$nam"
    Rename-Item "$temp" "$nam"
    cls
}
function Get-Number {
  param($inputString)

  if($inputString -match 'index=(\d+)'){
    return [int]$matches[1]
  }
  else{
    try{
      return [int]$inputString
    }
    catch{
      return "NaN"
    }
  }
}
function Get-Comment{
  param([string]$filename)
    return ffprobe -v quiet -show_entries format_tags=comment -of default=nw=1:nk=1 "$filename"
}
# MAIN SCRIPT
Add-Type -AssemblyName System.Windows.Forms

$dialog = New-Object System.Windows.Forms.FolderBrowserDialog
$dialog.Description = "Select a folder"

if ($dialog.ShowDialog() -eq "OK") {
    $path = $dialog.SelectedPath
    Write-Host "Selected folder: $path"
}
else {
  exit 1
}
cd $path
$names = (Get-ChildItem -File | Where-Object { $_.Extension -in '.mp4','.mkv'}).Name

foreach ($filename in $names) {
  $temp = Get-Number (Get-Comment -filename $filename)
  $temp = [int]$temp
  if($temp -lt 10){ $temp = [string]$temp
    $temp = "0$temp"}
    echo "Changing $filename : $temp - $filename"
  Rename-Item -LiteralPath "$filename" -NewName "$temp - $filename"
}
