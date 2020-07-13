# Reason Backup

This script will backup and restore Reason Rack Plugins (AAX, AU, and VST3). Backups are created in `~/.ReasonBackups`. Each time a backup is created, a new folder in `~/.ReasonBackups` is created, using the current date and time for the directory name. The restore option will restore the latest backup.

This has been tested on MacOS.


## Installation

* Clone this repo: `git clone git@github.com:jeffymahoney/ReasonBackup.git $HOME/ReasonBackup`
* Create an alias by adding the following to ~/.bash_profile: `alias reasonBackup="source $HOME/ReasonBackup/ReasonBackup.sh";`


## Usage

* Type `reasonBackup` in the terminal.
* Choose whether to Backup or Restore.
