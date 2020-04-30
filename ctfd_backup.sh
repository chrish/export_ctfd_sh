#!/bin/bash
#
# Copyright (c) 2020, Christoffer Hafsahl
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# This is a small script which can be used to automate backups of CTFd. 
# It works by logging in to the admin interface  and downloading 
# the export zip, allowing you to reimport at a later stage if needed. 
# Works fine with  CTFd 2.3.3. 
#
# Stuff you need to edit:
user=""
pass=""
url="url.to.ctfd"
backupdir="/path/to/backups/"

# See manpage for date for format options. 
# Also controls where the backup is stored.
# Default below is ctfd.2020.04.30_21:40.zip
datefm="+ctfd.%Y.%m.%d_%H:%M.zip"


# CTFd path to login and export:
login='/login'
exp='/admin/export'

# Misc other paths:
rm="/bin/rm"
curl="/usr/bin/curl -s"
date="/bin/date"

backupfn=$($date $datefm)

initial_request=$($curl -c "cookies.txt" $url)
regexp='csrf_nonce\ =\ \"[a-z0-99]+\"'

# Get nonce:
nonce=$(echo $initial_request | grep -P -o "$regexp" | cut -d \" -f 2)

# Logon
post_request=$($curl \
	--header 'Content-Type: application/x-www-form-urlencoded' \
	-b "cookies.txt" \
	-c "cookies_loggedin.txt" \
	--data-urlencode "name=$user" \
	--data-urlencode "password=$pass" \
	--data-urlencode "nonce=$nonce" \
	"$url$login")

# Get backup
backup_request=$($curl \
	-b cookies_loggedin.txt \
	"$url$exp" \
	> $backupdir$backupfn)

# Cleanup
$(rm cookies_loggedin.txt)
$(rm cookies.txt)
