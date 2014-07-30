# change this to a more permanent location, since the script relies on a persistent file
$chrdir = "$pwd"

# stop immediately if an error occurs
$erroractionpreference = "stop"

# the first part of the download URL, common to all architectures
$url = "https://commondatastorage.googleapis.com/chromium-browser-continuous/"

# determine architecture to download builds for
if ($env:processor_architecture -eq "AMD64") {
	$url += "Win_x64"
} else {
	$url += "Win"
}

# allows web queries
$client = new-object system.net.webclient

write-output "Querying remote version..."

# contains the latest build number
$remote = $client.downloadstring($url + "/LAST_CHANGE")

write-output "Remote version is $remote"

# this sentinel is changed if we find that the local version is out of date
$ood = 0

# if the persistent file exists
if (test-path $chrdir\ver.txt) {
	write-output "Querying local version..."

	$local = get-content $chrdir\ver.txt

	write-output "Local version is $local"

	# cast as int so a random string won't count as greater than the remote number
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

	# run installer; it works in the background
	& $chrdir\mini_installer.exe

	write-output "Updating local version cache..."

	# we've installed the remote version; update the cache accordingly
	$remote | set-content $chrdir\ver.txt
}

write-output "Local version is up to date"

write-output ""

write-host "Press any key to exit..."

# wait for the user to press a key before exiting, so the program's output can be read
$outputsuppress = $host.ui.rawui.readkey("noecho,includekeydown")
