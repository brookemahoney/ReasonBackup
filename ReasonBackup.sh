#!/bin/sh

backupDirectory="$HOME/.ReasonBackups";
vstDirectory="/Library/Audio/Plug-Ins/VST3";
vstPlugin1="$vstDirectory/Reason Rack Plugin.vst3";
vstPlugin2="$vstDirectory/Reason VST.vst3";

backup() {
  dateFormatted="$(date +%Y-%m-%d--%H-%M-%S)";
  newDirectory="$backupDirectory/$dateFormatted";

  mkdir -p "$newDirectory";
  if [ ! -d "$newDirectory" ]; then
    echo "Could not create backup directory.";
    return;
  fi

  if [ -d "$vstPlugin1" ]; then
    cp -R "$vstPlugin1" "$newDirectory";
    echo "Copied $vstPlugin1 to $newDirectory";
  else
    echo "$vstPlugin1 not found."
  fi

  if [ -d "$vstPlugin2" ]; then
    cp -R "$vstPlugin2" "$newDirectory";
    echo "Copied $vstPlugin2 to $newDirectory";
  else
    echo "$vstPlugin2 not found."
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

  cp -R "$latestDirectory/" "$vstDirectory";
  echo "VST plugins restored";
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
