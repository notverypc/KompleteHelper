set AdminUser to "AdminUserAccount"
set AdminPassword to "AdminPassword"

-- Set Location of Komplete Folder and then open all disk images
tell application "Finder"
	set fl to files of folder POSIX file "/MusicTech/Komplete 8/" as alias list
	
	repeat with f in fl
		do shell script ("hdiutil mount \"" & ¬
			POSIX path of (f as string) & "\"")
	end repeat
end tell

-- Not sure if needed but I'll leave it
delay 5


-- Set Location of Komplete Installer
set KompleteInstaller to the quoted form of the POSIX path of "/Volumes/Komplete 8/Komplete 8 Installer Mac.mpkg"

do shell script "/usr/sbin/installer -package " & KompleteInstaller & " -target / " user name AdminUser password AdminPassword with administrator privileges

-- Munki Catalog & Kickstarter
do shell script "touch /Users/Shared/.com.googlecode.munki.checkandinstallatstartup"

-- Disable AutoLogin
do shell script "defaults delete /Library/Preferences/com.apple.loginwindow autoLoginUser" user name AdminUser password AdminPassword with administrator privileges
do shell script "rm /etc/kcpassword" user name AdminUser password AdminPassword with administrator privileges

-- The Big Finish
display dialog "Komplete Installer has Finished" buttons {"OK"} default button 1 with icon caution giving up after 5

-- Restart Mac
do shell script "shutdown -r now" user name AdminUser password AdminPassword with administrator privileges
