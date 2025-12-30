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

$extensions = "*.mp4","*.mkv","*.avi","*.webm"
Get-ChildItem $extensions |
    Sort-Object {
        if ($_.BaseName -match '^\d+') { [int]$matches[0] } else { 0 }
    } |
    ForEach-Object { $_.Name } |
    Set-Content playlist.m3u -Encoding UTF8
