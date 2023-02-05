# Start timer
$start = Get-Date

# Open Notepad
Start-Process -FilePath "notepad.exe"
$timeOpen = (Get-Date) - $start

# Wait for 10 seconds
Start-Sleep -Seconds 10
$timeSleep = (Get-Date) - $start - $timeOpen

# Type text in Notepad
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait("Sample text")
$timeType = (Get-Date) - $start - $timeOpen - $timeSleep

# Close Notepad
Get-Process -Name notepad | Stop-Process
$timeClose = (Get-Date) - $start - $timeOpen - $timeSleep - $timeType

# Open File Explorer
Start-Process -FilePath "explorer.exe"
$timeFileExplorerOpen = (Get-Date) - $start - $timeOpen - $timeSleep - $timeType - $timeClose

# Wait for 5 seconds
Start-Sleep -Seconds 5
$timeFileExplorerSleep = (Get-Date) - $start - $timeOpen - $timeSleep - $timeType - $timeClose - $timeFileExplorerOpen

# Close File Explorer
Get-Process -Name explorer | Stop-Process
$timeFileExplorerClose = (Get-Date) - $start - $timeOpen - $timeSleep - $timeType - $timeClose - $timeFileExplorerOpen - $timeFileExplorerSleep

# Stop timer
$end = Get-Date
$totalTime = $end - $start

# Create time table
$timeTable = [PSCustomObject]@{
    "Action" = "Open Notepad";
    "Time" = $timeOpen
}, [PSCustomObject]@{
    "Action" = "Wait for 10 seconds";
    "Time" = $timeSleep
}, [PSCustomObject]@{
    "Action" = "Type text in Notepad";
    "Time" = $timeType
}, [PSCustomObject]@{
    "Action" = "Close Notepad";
    "Time" = $timeClose
}, [PSCustomObject]@{
    "Action" = "Open File Explorer";
    "Time" = $timeFileExplorerOpen
}, [PSCustomObject]@{
    "Action" = "Wait for 5 seconds";
    "Time" = $timeFileExplorerSleep
}, [PSCustomObject]@{
    "Action" = "Close File Explorer";
    "Time" = $timeFileExplorerClose
}, [PSCustomObject]@{
    "Action" = "Total time";
    "Time" = $totalTime
}

# Output time table to CSV file
$date = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$filePath = "statistics_$date.csv"
$timeTable | Export-Csv -Path $filePath -NoTypeInformation

# Display file path
Write-Host "Time table saved to $filePath"
