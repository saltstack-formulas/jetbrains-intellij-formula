#!/usr/bin/env bash

Source="{{ appname }}{{ ' %sE'|format(edition) if edition is defined and edition else '' }}.app"
Destination="{{ homes }}/{{ user }}/Desktop"
/usr/bin/osascript -e "tell application \"Finder\" to make alias file to POSIX file \"$Source\" at POSIX file \"$Destination\""
