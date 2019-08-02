$Service = "spooler"
$QueueStore = Join-Path -Path $env:windir -ChildPath "System32\spool\PRINTERS"

Stop-Service $Service
Remove-Item (Join-Path -Path $QueueStore -ChildPath "*")
Start-Service $Service
