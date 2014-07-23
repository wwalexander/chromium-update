# change this to a more permanent location, since the script relies on a persistent file
$chrdir = "$pwd"

# stop immediately if an error occurs
$erroractionpreference = "stop"

# allows web queries
$client = new-object system.net.webclient

echo "Querying remote version..."

# contains the latest build number
$remote = $client.downloadstring("https://commondatastorage.googleapis.com/chromium-browser-snapshots/Win/LAST_CHANGE")

echo "Remote version is $remote"

# this sentinel is changed if we find that the local version is out of date
$ood = 0

# if the persistent file exists
if (test-path $chrdir\ver.txt) {
	echo "Querying local version..."

	$local = get-content $chrdir\ver.txt

	echo "Local version is $local"

	# cast as int so a random string won't count as greater than the remote number
	if ($remote -gt $local -as [int]) {
		$ood = 1
	}
}
else {
	echo "No local version cache found"

	$ood = 1
}

if ($ood) {
	echo "Downloading remote version..."

	$client.downloadfile("https://commondatastorage.googleapis.com/chromium-browser-snapshots/Win/$remote/mini_installer.exe", "$chrdir\mini_installer.exe")

	echo "Installing new version..."

	# run installer; it works in the background
	& $chrdir\mini_installer.exe

	echo "Updating local version cache..."

	# we've installed the remote version; update the cache accordingly
	$remote | set-content $chrdir\ver.txt
}

echo "Local version is up to date"
