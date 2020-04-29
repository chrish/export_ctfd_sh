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
user="username"
pass="password"
url="https://url.to.ctfd"


# CTFd path to login and export:
login='/login'
exp='/admin/export'

# See date manpage for format options. 
# Also controls where the backup is stored.
datefm="+backups/ctfd_backup.%Y.%m.%d_%H:%I.zip"

# Misc other paths:
rm="/bin/rm"
curl="/usr/bin/curl"
date="/bin/date"

backupfn=$($date $datefm)

initial_request=$($curl -c "cookies.txt" -s $url)
regexp='csrf_nonce\ =\ \"[a-z0-99]+\"'

# Get nonce:
nonce=$(echo $initial_request | grep -P -o "$regexp" | cut -d \" -f 2)

# Logon
post_request=$($curl \
	--header 'Content-Type: application/x-www-form-urlencoded' \
	-s \
	-b "cookies.txt" \
	-c "cookies_loggedin.txt" \
	--data-urlencode "name=$user" \
	--data-urlencode "password=$pass" \
	--data-urlencode "nonce=$nonce" \
	"$url$login")

# Get backup
backup_request=$($curl \
	-b cookies_loggedin.txt \
	-s \
	"$url$exp" \
	> $backupfn)

# Cleanup
$($rm cookies_loggedin.txt)
$($rm cookies.txt)
