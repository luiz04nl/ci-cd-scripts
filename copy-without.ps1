# Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

$directoryPath = "src"

Get-ChildItem -Path $directoryPath -Filter "Web.*.config" | Where-Object { $_.Name -ne "Web.config" } | ForEach-Object {
    Remove-Item $_.FullName -Force
    Write-Host "Removed:" $_.FullName
}