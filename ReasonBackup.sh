#!/bin/sh

backupDirectory="$HOME/.ReasonBackups";
pluginsDirectory="/Library/Audio/Plug-Ins";
vstPlugin1="$pluginsDirectory/VST3/Reason Rack Plugin.vst3";
vstPlugin2="$pluginsDirectory/VST3/Reason VST.vst3";
auPlugin="$pluginsDirectory/Components/Reason Rack Plugin.component"

fixPermissions() {
  if [ -d "$vstPlugin1" ]; then
    chmod -R u+w  "$vstPlugin1"
  fi

  if [ -d "$vstPlugin2" ]; then
    chmod -R u+w  "$vstPlugin2"
  fi

  if [ -d "$auPlugin" ]; then
    chmod -R u+w  "$auPlugin"
  fi
}

backup() {
  dateFormatted="$(date +%Y-%m-%d--%H-%M-%S)";
  newDirectory="$backupDirectory/$dateFormatted";

  mkdir -p "$newDirectory";
  if [ ! -d "$newDirectory" ]; then
    echo "Could not create backup directory.";
    return;
  fi

  if [ -d "$vstPlugin1" ]; then
    cp -R "$vstPlugin1" "$newDirectory/VST3";
    echo "Copied $vstPlugin1 to $newDirectory/VST3";
  else
    echo "$vstPlugin1 not found."
  fi

  if [ -d "$vstPlugin2" ]; then
    cp -R "$vstPlugin2" "$newDirectory/VST3";
    echo "Copied $vstPlugin2 to $newDirectory/VST3";
  else
    echo "$vstPlugin2 not found."
  fi

  if [ -d "$auPlugin" ]; then
    cp -R "$auPlugin" "$newDirectory/Components";
    echo "Copied $auPlugin to $newDirectory/Components";
  else
    echo "$auPlugin not found."
  fi
}

restore() {
  if [ ! -d "$backupDirectory" ]; then
    echo "No backups found.";
    return;
  fi

  cd "$backupDirectory" || return;
  latestDirectory="$(ls -t | head -1)";
  if [ -z "$latestDirectory" ]; then
    echo "No backups found";
    return;
  fi

  fixPermissions;
  cp -R "$latestDirectory/" "$pluginsDirectory";
  echo "Plugins restored";
}

PS3='Backup or Restore?: '
select action in "Backup" "Restore"; do
  case $action in
  "Backup")
    backup
    break
    ;;
  "Restore")
    restore
    break
    ;;
  esac
done
