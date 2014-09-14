#!/usr/bin/env sh
 
set -e
 
# Respect PREFIX if set, otherwise default to /usr/local
if [ -z "${PREFIX}" ]; then
  PREFIX="/usr/local"
fi
 
# Respect TMPDIR if set, otherwise default to /tmp
if [ -z "$TMPDIR" ]; then
  TMP="/tmp"
else
  TMP="${TMPDIR%/}"
fi
 
BIN_PATH="${PREFIX}/bin"
LIB_PATH="${PREFIX}/lib/nuget"
SEED="$(date "+%Y%m%d%H%M%S").$$"
TEMP_PATH="${TMP}/nuget-curl.${SEED}"
CWD="$(pwd)"
 
# Create our TEMP_PATH directory
mkdir -p "$TEMP_PATH"
 
# Download nuget.exe to our temp path
echo "*** Downloading NuGet.exe..."
cd "$TEMP_PATH"
curl -s -O http://anglicangeek.com/nuget.exe
cd "$CWD"
 
# Remove old nuget
rm -rf "${LIB_PATH}/nuget.exe"
 
# Move downloaded nuget.exe to LIB_PATH
echo "*** Installing NuGet.exe..."
mkdir -p "$LIB_PATH"
mv "${TEMP_PATH}/nuget.exe" "${LIB_PATH}/nuget.exe"
 
# Remove old proxy script
rm -rf "${BIN_PATH}/nuget"
 
# Create new proxy script
echo "#!/bin/sh" >> "${BIN_PATH}/nuget"
echo "mono --runtime=v4.0.30319 ${LIB_PATH}/nuget.exe \"\$@\"" >> "${BIN_PATH}/nuget"
chmod a+x "${BIN_PATH}/nuget"
 
# Install Certificates
mozroots --import --ask-remove
 
# Clean Up
echo "*** Cleaning Up..."
rm -rf "$TEMP_PATH"
 
# All done
echo "*** Installed"