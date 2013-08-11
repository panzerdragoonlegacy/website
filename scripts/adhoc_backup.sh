#!/bin/bash
echo "Running script to create an adhoc backup of The Will of the Ancients..."

function set_file_name() {
  echo "Setting file_name variable..."
  right_now=$(date +"%Y-%m-%d-%H-%M-%S")
  file_name="thewilloftheancients-$right_now"
}

function create_backup_directory() {
  echo "Creating backup directory..."
  backup_dir="/home/chrisalley/backups/thewilloftheancients/$file_name"
  mkdir $backup_dir
  echo "Backup directory created."
}

function create_database_dumps() {
  echo "Creating dump of the main site's database..."
  /usr/local/pgsql/bin/pg_dump -Fp -b -U chrisalley_thewilloftheancients chrisalley_thewilloftheancients > $backup_dir/thewilloftheancients.sql
  if (( $? )); then
    echo "Could not create database dump of the main site's database."
    remove_backup_directory
    exit 1
  else
    echo "Dump of the main site's database created."
    echo "Creating dump of the forum database..."
    mysqldump chrisalley_twota -uchrisalley_twota -p > $backup_dir/twotaforums.sql
    if (( $? )); then
      echo "Could not create database dump of the forum database."
      remove_backup_directory
      exit 1
    else
      echo "Dump of the forum database created."
    fi
  fi
}

function copy_webapp_directories() {
  echo "Copying The Will of the Ancients webapp directory to backup directory..."
  cp -r /home/chrisalley/webapps/thewilloftheancients $backup_dir
  if (( $? )); then
    echo "Could not copy The Will of the Ancients webapp directory."
    remove_backup_directory
    exit 1
  else
    echo "The Will of the Ancients webapp directory copied."
    echo "Copying The Will of the Ancients Forums webapp directory to backup directory..."
    cp -r /home/chrisalley/webapps/twotaforums $backup_dir
    if (( $? )); then
      echo "Could not copy The Will of the Ancients Forums webapp directory."
      remove_backup_directory
      exit 1
    else
      echo "The Will of the Ancients Forums webapp directory copied."
    fi
  fi
}

function compress_files() {
  echo "Compressing database dumps and webapp directories..."
  cd /home/chrisalley/backups/thewilloftheancients
  tar -zcvf /home/chrisalley/backups/thewilloftheancients/$file_name.tar.gz $file_name
  if (( $? )); then
    echo "Could not create compressed file."
    remove_backup_directory
    exit 1
  else
    echo "Database dumps and webapp directories compressed."
  fi 
}

function remove_backup_directory() {
  echo "Removing uncompressed backup directory..."
  rm -rf $backup_dir
  echo "Uncompressed backup directory removed."
}

set_file_name
create_backup_directory
create_database_dumps
copy_webapp_directories
compress_files
remove_backup_directory
echo "Backup successful. Filename: $file_name.tar.gz" 
exit 0