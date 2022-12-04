#checking files
$filestocheck = "c:\filename.p1"

#module von github laden
Import-Module https://raw.githubusercontent.com/cbshearer/get-VTFileReport/master/get-VTFileReport.psm1

#create filehash
$filehash = Get-FileHash -Algorithm SHA256 -Path $filestocheck

#check filehash
get-VTFileReport -h $filehash

#we>>mer