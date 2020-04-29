This is a small script which can be used to automate backups of CTFd. 

It works by logging in to the admin interface using curl, downloading the export zip and allowing you to reimport at a later stage if needed. Backups are stored in a backup-directory, and files are named "ctfd_backup YEAR.MONTH.DAY HOUR:MINUTE.zip" as-is, but this is easy to change. 

Tested and found to work fine with  CTFd 2.3.3. It should also work with any other version, as long as the paths to the login and export pages as well as the login method doesn't change.

Everything is licensed under the BSD 2-clause license, so please use it as you see fit.
