#!/bin/sh

backupDirectory="$HOME/.ReasonBackups";

libraryPluginsDirectory="/Library/Audio/Plug-Ins";
auPlugin="$libraryPluginsDirectory/Components/Reason Rack Plugin.component";
vstPlugin1="$libraryPluginsDirectory/VST3/Reason Rack Plugin.vst3";
vstPlugin2="$libraryPluginsDirectory/VST3/Reason VST.vst3";

aaxPluginsDirectory="/Library/Application Support/Avid/Audio/Plug-Ins";
aaxPlugin="$aaxPluginsDirectory/Reason Rack Plugin.aaxplugin";

fixPermissions() {
  if [ -d "$aaxPlugin" ]; then
    chmod -R ug+w  "$aaxPlugin"
  fi

  if [ -d "$auPlugin" ]; then
    chmod -R ug+w  "$auPlugin"
  fi

  if [ -d "$vstPlugin1" ]; then
    chmod -R ug+w  "$vstPlugin1"
  fi

  if [ -d "$vstPlugin2" ]; then
    chmod -R ug+w  "$vstPlugin2"
  fi
}

backup() {
  dateFormatted="$(date +%Y-%m-%d--%H-%M-%S)";
  newLibraryComponentsDirectory="$backupDirectory/$dateFormatted/Library/Components";
  newLibraryVST3Directory="$backupDirectory/$dateFormatted/Library/VST3";
  newAAXPluginsDirectory="$backupDirectory/$dateFormatted/AAX";

  mkdir -p "$newLibraryComponentsDirectory";
  if [ ! -d "$newLibraryComponentsDirectory" ]; then
    echo "Could not create backup directory.";
    return;
  fi

  mkdir -p "$newLibraryVST3Directory";
  if [ ! -d "$newLibraryVST3Directory" ]; then
    echo "Could not create backup directory.";
    return;
  fi

  mkdir -p "$newAAXPluginsDirectory";
  if [ ! -d "$newAAXPluginsDirectory" ]; then
    echo "Could not create backup directory.";
    return;
  fi

  if [ -d "$aaxPlugin" ]; then
    cp -R "$aaxPlugin" "$newAAXPluginsDirectory";
    echo "Copied $aaxPlugin to $newAAXPluginsDirectory";
  else
    echo "$aaxPlugin not found."
  fi

  if [ -d "$auPlugin" ]; then
    cp -R "$auPlugin" "$newLibraryComponentsDirectory";
    echo "Copied $auPlugin to $newLibraryComponentsDirectory";
  else
    echo "$auPlugin not found."
  fi

  if [ -d "$vstPlugin1" ]; then
    cp -R "$vstPlugin1" "$newLibraryVST3Directory";
    echo "Copied $vstPlugin1 to $newLibraryVST3Directory";
  else
    echo "$vstPlugin1 not found."
  fi

  if [ -d "$vstPlugin2" ]; then
    cp -R "$vstPlugin2" "$newLibraryVST3Directory";
    echo "Copied $vstPlugin2 to $newLibraryVST3Directory";
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

  fixPermissions;
  cp -R "$latestDirectory/AAX/" "$aaxPluginsDirectory";
  cp -R "$latestDirectory/Library/" "$libraryPluginsDirectory";
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
