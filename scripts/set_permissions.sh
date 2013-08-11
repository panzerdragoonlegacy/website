echo "Setting permissions for website administrators..."

setfacl -m u:mattodonnell:--x ~
setfacl -R -m u:mattodonnell:--- ~/webapps/*
setfacl -R -m d:u:mattodonnell:--- ~/webapps/*
setfacl -R -m u:mattodonnell:rwx ~/webapps/thewilloftheancients
setfacl -R -m d:u:mattodonnell:rwx ~/webapps/thewilloftheancients
setfacl -R -m u:mattodonnell:rwx ~/webapps/thewilloftheancientsforums
setfacl -R -m d:u:mattodonnell:rwx ~/webapps/thewilloftheancientsforums
setfacl -R -m u:mattodonnell:rwx ~/webapps/thewilloftheancientsstorage
setfacl -R -m d:u:mattodonnell:rwx ~/webapps/thewilloftheancientsstorage
setfacl -R -m u:mattodonnell:--- ~/backups/*
setfacl -R -m d:u:mattodonnell:--- ~/backups/*
setfacl -R -m u:mattodonnell:rwx ~/backups/thewilloftheancients
setfacl -R -m d:u:mattodonnell:rwx ~/backups/thewilloftheancients
setfacl -R -m u:mattodonnell:rwx ~/webapps/skyridertheimperialarchives
setfacl -R -m d:u:mattodonnell:rwx ~/webapps/skyridertheimperialarchives
setfacl -R -m u:mattodonnell:rwx ~/webapps/theartofpanzerdragoon
setfacl -R -m d:u:mattodonnell:rwx ~/webapps/theartofpanzerdragoon
setfacl -R -m u:mattodonnell:rwx ~/webapps/thepanzerdragoonacademyawards
setfacl -R -m d:u:mattodonnell:rwx ~/webapps/thepanzerdragoonacademyawards
setfacl -R -m u:mattodonnell:rwx ~/webapps/thepanzerdragoonsagaoasis
setfacl -R -m d:u:mattodonnell:rwx ~/webapps/thepanzerdragoonsagaoasis
setfacl -R -m u:mattodonnell:rwx ~/webapps/thepanzerplace
setfacl -R -m d:u:mattodonnell:rwx ~/webapps/thepanzerplace

setfacl -R -m u:mattodonnell:rwx ~/webapps/urbanreflex
setfacl -R -m d:u:mattodonnell:rwx ~/webapps/urbanreflex

setfacl -m u:miguelpolfliet:--x ~
setfacl -R -m u:miguelpolfliet:--- ~/webapps/*
setfacl -R -m d:u:miguelpolfliet:--- ~/webapps/*
setfacl -R -m u:miguelpolfliet:rwx ~/webapps/thewilloftheancients
setfacl -R -m d:u:miguelpolfliet:rwx ~/webapps/thewilloftheancients
setfacl -R -m u:miguelpolfliet:rwx ~/webapps/thewilloftheancientsforums
setfacl -R -m d:u:miguelpolfliet:rwx ~/webapps/thewilloftheancientsforums
setfacl -R -m u:miguelpolfliet:rwx ~/webapps/thewilloftheancientsstorage
setfacl -R -m d:u:miguelpolfliet:rwx ~/webapps/thewilloftheancientsstorage
setfacl -R -m u:miguelpolfliet:--- ~/backups/*
setfacl -R -m d:u:miguelpolfliet:--- ~/backups/*
setfacl -R -m u:miguelpolfliet:rwx ~/backups/thewilloftheancients
setfacl -R -m d:u:miguelpolfliet:rwx ~/backups/thewilloftheancients
setfacl -R -m u:miguelpolfliet:rwx ~/webapps/skyridertheimperialarchives
setfacl -R -m d:u:miguelpolfliet:rwx ~/webapps/skyridertheimperialarchives
setfacl -R -m u:miguelpolfliet:rwx ~/webapps/theartofpanzerdragoon
setfacl -R -m d:u:miguelpolfliet:rwx ~/webapps/theartofpanzerdragoon
setfacl -R -m u:miguelpolfliet:rwx ~/webapps/thepanzerdragoonacademyawards
setfacl -R -m d:u:miguelpolfliet:rwx ~/webapps/thepanzerdragoonacademyawards
setfacl -R -m u:miguelpolfliet:rwx ~/webapps/thepanzerdragoonsagaoasis
setfacl -R -m d:u:miguelpolfliet:rwx ~/webapps/thepanzerdragoonsagaoasis
setfacl -R -m u:miguelpolfliet:rwx ~/webapps/thepanzerplace
setfacl -R -m d:u:miguelpolfliet:rwx ~/webapps/thepanzerplace

setfacl -m u:geoffreyduke:--x ~
setfacl -R -m u:geoffreyduke:--- ~/webapps/*
setfacl -R -m d:u:geoffreyduke:--- ~/webapps/*
setfacl -R -m u:geoffreyduke:rwx ~/webapps/thewilloftheancients
setfacl -R -m d:u:geoffreyduke:rwx ~/webapps/thewilloftheancients
setfacl -R -m u:geoffreyduke:rwx ~/webapps/thewilloftheancientsforums
setfacl -R -m d:u:geoffreyduke:rwx ~/webapps/thewilloftheancientsforums
setfacl -R -m u:geoffreyduke:rwx ~/webapps/thewilloftheancientsstorage
setfacl -R -m d:u:geoffreyduke:rwx ~/webapps/thewilloftheancientsstorage
setfacl -R -m u:geoffreyduke:--- ~/backups/*
setfacl -R -m d:u:geoffreyduke:--- ~/backups/*
setfacl -R -m u:geoffreyduke:rwx ~/backups/thewilloftheancients
setfacl -R -m d:u:geoffreyduke:rwx ~/backups/thewilloftheancients
setfacl -R -m u:geoffreyduke:rwx ~/webapps/skyridertheimperialarchives
setfacl -R -m d:u:geoffreyduke:rwx ~/webapps/skyridertheimperialarchives
setfacl -R -m u:geoffreyduke:rwx ~/webapps/theartofpanzerdragoon
setfacl -R -m d:u:geoffreyduke:rwx ~/webapps/theartofpanzerdragoon
setfacl -R -m u:geoffreyduke:rwx ~/webapps/thepanzerdragoonacademyawards
setfacl -R -m d:u:geoffreyduke:rwx ~/webapps/thepanzerdragoonacademyawards
setfacl -R -m u:geoffreyduke:rwx ~/webapps/thepanzerdragoonsagaoasis
setfacl -R -m d:u:geoffreyduke:rwx ~/webapps/thepanzerdragoonsagaoasis
setfacl -R -m u:geoffreyduke:rwx ~/webapps/thepanzerplace
setfacl -R -m d:u:geoffreyduke:rwx ~/webapps/thepanzerplace

ln -s /home/chrisalley/webapps/thewilloftheancients /home/mattodonnell/thewilloftheancients
ln -s /home/chrisalley/webapps/thewilloftheancientsforums /home/mattodonnell/thewilloftheancientsforums
ln -s /home/chrisalley/webapps/thewilloftheancientsstorage /home/mattodonnell/thewilloftheancientsstorage
ln -s /home/chrisalley/backups/thewilloftheancients /home/mattodonnell/thewilloftheancientsbackups
ln -s /home/chrisalley/webapps/skyridertheimperialarchives /home/mattodonnell/skyridertheimperialarchives
ln -s /home/chrisalley/webapps/theartofpanzerdragoon /home/mattodonnell/theartofpanzerdragoon
ln -s /home/chrisalley/webapps/thepanzerdragoonacademyawards /home/mattodonnell/thepanzerdragoonacademyawards
ln -s /home/chrisalley/webapps/thepanzerdragoonsagaoasis /home/mattodonnell/thepanzerdragoonsagaoasis
ln -s /home/chrisalley/webapps/thepanzerplace /home/mattodonnell/thepanzerplace

ln -s /home/chrisalley/webapps/urbanreflex /home/mattodonnell/urbanreflex

ln -s /home/chrisalley/webapps/thewilloftheancients /home/miguelpolfliet/thewilloftheancients
ln -s /home/chrisalley/webapps/thewilloftheancientsforums /home/miguelpolfliet/thewilloftheancientsforums
ln -s /home/chrisalley/webapps/thewilloftheancientsstorage /home/miguelpolfliet/thewilloftheancientsstorage
ln -s /home/chrisalley/backups/thewilloftheancients /home/miguelpolfliet/thewilloftheancientsbackups
ln -s /home/chrisalley/webapps/skyridertheimperialarchives /home/miguelpolfliet/skyridertheimperialarchives
ln -s /home/chrisalley/webapps/theartofpanzerdragoon /home/miguelpolfliet/theartofpanzerdragoon
ln -s /home/chrisalley/webapps/thepanzerdragoonacademyawards /home/miguelpolfliet/thepanzerdragoonacademyawards
ln -s /home/chrisalley/webapps/thepanzerdragoonsagaoasis /home/miguelpolfliet/thepanzerdragoonsagaoasis
ln -s /home/chrisalley/webapps/thepanzerplace /home/miguelpolfliet/thepanzerplace

ln -s /home/chrisalley/webapps/thewilloftheancients /home/geoffreyduke/thewilloftheancients
ln -s /home/chrisalley/webapps/thewilloftheancientsforums /home/geoffreyduke/thewilloftheancientsforums
ln -s /home/chrisalley/webapps/thewilloftheancientsstorage /home/geoffreyduke/thewilloftheancientsstorage
ln -s /home/chrisalley/backups/thewilloftheancients /home/geoffreyduke/thewilloftheancientsbackups
ln -s /home/chrisalley/webapps/skyridertheimperialarchives /home/geoffreyduke/skyridertheimperialarchives
ln -s /home/chrisalley/webapps/theartofpanzerdragoon /home/geoffreyduke/theartofpanzerdragoon
ln -s /home/chrisalley/webapps/thepanzerdragoonacademyawards /home/geoffreyduke/thepanzerdragoonacademyawards
ln -s /home/chrisalley/webapps/thepanzerdragoonsagaoasis /home/geoffreyduke/thepanzerdragoonsagaoasis
ln -s /home/chrisalley/webapps/thepanzerplace /home/geoffreyduke/thepanzerplace

