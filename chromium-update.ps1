$chrdir = "$env:APPDATA\chromium-update"

if (-not (test-path $chrdir)) {
	new-item "$chrdir" -type directory
}

$erroractionpreference = "stop"
$url = "https://commondatastorage.googleapis.com/chromium-browser-continuous/"

if ($env:processor_architecture -eq "AMD64") {
	$url += "Win_x64"
} else {
	$url += "Win"
}

$client = new-object system.net.webclient
write-output "Querying remote version..."
$remote = $client.downloadstring($url + "/LAST_CHANGE")
write-output "Remote version is $remote"
$ood = 0

if (test-path $chrdir\ver.txt) {
	write-output "Querying local version..."
	$local = get-content $chrdir\ver.txt
	write-output "Local version is $local"

	if ($remote -ne $local -as [int]) {
		$ood = 1
	}
}
else {
	write-output "No local version cache found"
	$ood = 1
}

if ($ood) {
	write-output "Downloading remote version..."
	$client.downloadfile($url + "/" + $remote + "/mini_installer.exe", "$chrdir\mini_installer.exe")
	write-output "Installing new version..."
	& $chrdir\mini_installer.exe
	write-output "Updating local version cache..."
	$remote | set-content $chrdir\ver.txt
}

write-output "Local version is up to date"
