#!/usr/bin/env bash

# Thanks to Mathias Bynens!
# ~/.macos — https://mths.be/macos

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# Updates                                                                     #
###############################################################################

# Enable Automatic App Store Updates
defaults write /Library/Preferences/com.apple.commerce.plist AutoUpdate -bool true 

# Enable Automatic Security Updates
defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool true 

# Automatically check for updates
defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true 

# Automatically download updates
defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool true 

# Disable General Auto-updates
defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticallyInstallMacOSUpdates -bool false 

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Show IP, Hostname, Build# on lockscreen when clock is clicked
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

###############################################################################
# Energy saving                                                               #
###############################################################################

# Automatically wake every day at 6:00 AM
sudo pmset repeat wake MTWRFSU 6:00:00

# Restart automatically on power loss
sudo pmset -a autorestart 1

# Sleep the display after 120 minutes
sudo pmset -a displaysleep 120

# Disable machine sleep while charging
sudo pmset -c sleep 0

# Never go into computer sleep mode
sudo systemsetup -setcomputersleep Off > /dev/null

###############################################################################
# Finder                                                                      #
###############################################################################

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

###############################################################################
# Time Machine                                                                #
###############################################################################

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

###############################################################################
# Activity Monitor                                                            #
###############################################################################

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Activity Monitor" \
    "cfprefsd" \
    "Finder" \
    "SystemUIServer"; do
    killall "${app}" &> /dev/null
done
echo "Done. Note that some of these changes require a logout/restart to take effect."
