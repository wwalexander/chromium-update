$erroractionpreference = "stop"
$url = "https://commondatastorage.googleapis.com/chromium-browser-continuous/"

if ($env:PROCESSOR_ARCHITECTURE -eq "AMD64") {
	$url += "Win_x64"
} else {
	$url += "Win"
}

$client = New-Object System.Net.WebClient
Write-Output "Querying remote version..."
$remote = $client.DownloadString($url + "/LAST_CHANGE")
write-output "Remote version is $remote"
$ood = 0

if (Test-Path ver.txt) {
	Write-Output "Querying local version..."
	$local = Get-Content ver.txt
	Write-Output "Local version is $local"

	if ($remote -ne $local -as [int]) {
		$ood = 1
	}
} else {
	Write-Output "No local version cache found"
	$ood = 1
}

$fname = "mini_installer.exe"

if ($ood) {
	Write-Output "Downloading remote version..."
	$client.DownloadFile($url + "/" + $remote + "/$fname", "$fname")
	Write-Output "Installing new version..."
	& "./$fname"
	Write-Output "Updating local version cache..."
	$remote | Set-Content ver.txt
}

Write-Output "Local version is up to date"
