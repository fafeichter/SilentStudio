#!/bin/zsh

rm -f SilentStudio

swiftc SilentStudio.swift IOServiceConnection.swift -o SilentStudio
swiftc SilentStudioMenuApp.swift IOServiceConnection.swift -o SilentStudioMenu

sudo chown root SilentStudio
sudo chmod +s SilentStudio