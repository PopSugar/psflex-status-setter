#!/bin/bash
# PopSugar wifi ssid
MYWORKSSID="POPSUGAR"

SLACKAPIKEY=`osascript -e 'set T to text returned of (display dialog "Enter your Slack OAuth API key" buttons {"Cancel", "OK"} default button "OK" default answer "" with hidden answer)'`
# Setting times to sleep in the script
STARTHOUR=`osascript -e 'set T to text returned of (display dialog "What hour do you get to work?" buttons {"Cancel", "OK"} default button "OK" default answer 8)'`
ENDHOUR=`osascript -e 'set T to text returned of (display dialog "What hour do you leave work?" buttons {"Cancel", "OK"} default button "OK" default answer 17)'`

# Detemine if api key is valid
IS_VALID=`curl https://slack.com/api/auth.test --data 'token='$SLACKAPIKEY |     python -c "import sys, json; print json.load(sys.stdin)['ok']"`

if [ $IS_VALID == "True" ]; then
	slackstatus_shell_path="/Users/"$USER"/Library/LaunchAgents/slackstatus.sh"
	slackstatus_plist_path="/Users/"$USER"/Library/LaunchAgents/local.slackstatus.plist"

	cat <<< "#!/bin/bash
while [ \`date +%H\` -gt $ENDHOUR ] && [ \`date +%H\` -lt $STARTHOUR ]
do
sleep 1h
done
ssid=\`/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr(\$0, index(\$0, \$2))}'\`
slack_token=\""$SLACKAPIKEY"\"

if [ \"\$ssid\" == \"$MYWORKSSID\" ]; then
    # set status to 'In the Office'
    /usr/bin/curl https://slack.com/api/users.profile.set --data 'token='\$slack_token'&profile=%7B%22status_text%22%3A%20%22In%20the%20Office%22%2C%22status_emoji%22%3A%20%22%3Aoffice%3A%22%7D' > /dev/null
else
    # set status to 'Working Remotely'
    /usr/bin/curl https://slack.com/api/users.profile.set --data 'token='\$slack_token'&profile=%7B%22status_text%22%3A%20%22Working%20Remotely%22%2C%22status_emoji%22%3A%20%22%3Ahouse_with_garden%3A%22%7D' > /dev/null
fi" > $slackstatus_shell_path
	chmod a+x $slackstatus_shell_path
	cat <<< '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>local.slackstatus</string>
  <key>ProgramArguments</key>
  <array>
  <string>'$slackstatus_shell_path'</string>
  </array>
  <key>WatchPaths</key>
  <array>
    <string>/etc/resolv.conf</string>
    <string>/Library/Preferences/SystemConfiguration/NetworkInterfaces.plist</string>
    <string>/Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
</dict>
</plist>' > $slackstatus_plist_path
	launchctl unload -w $slackstatus_plist_path
	launchctl load -w $slackstatus_plist_path
else
	osascript -e 'display dialog "We could not verify that token" buttons {"Cancel", "OK"} default button "OK"'
fi
