#!/bin/bash

function success {
  echo -e "$(tput bold)$(tput setaf 2)[✓]$(tput sgr0)"
}
function warn {
  echo -e "$(tput sgr 0 1)$(tput setaf 3)$1$(tput sgr0)"
}
function error {
  echo -e "$(tput bold)$(tput setaf 1)[✗]$(tput sgr0)"
}

# Welcome
# -----------------------------------------------

echo
echo "Welcome! Looks like you wiped your computer again."
echo "Let's start from scratch, shall we?"
echo

# OS X
# -----------------------------------------------

echo "Configure OS X? (Y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then

  # System
  echo -ne "Configuring System... "
    {
      launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist
      killall NotificationCenter
    } &> /dev/null
    defaults write NSGlobalDomain KeyRepeat -int 0
    defaults write com.apple.screensaver askForPassword -int 1
    defaults write com.apple.screensaver askForPasswordDelay -int 0
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode -string "TwoButton"
    defaults write NSGlobalDomain com.apple.sound.beep.feedback -integer 0
    defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
    killall SystemUIServer
  success

  # Finder
  echo -ne "Configuring Finder... "
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
    defaults write com.apple.Finder AppleShowAllFiles -bool true
    defaults write com.apple.finder CreateDesktop -bool false
    killall Finder
  success

  # Dock
  echo -ne "Configuring Dock... "
    defaults write com.apple.dock tilesize -int 60
    defaults write com.apple.dock orientation -string "right"
    defaults write com.apple.dock autohide -bool true
    killall Dock
  success

  # Safari
  echo -ne "Configuring Safari... "
    defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
    defaults write com.apple.Safari IncludeDevelopMenu -bool true
    defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
    defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
    defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
  success
fi

echo

# Command Line Tools
# -----------------------------------------------

# Check if command line tools exist
which -s xcode-select
if [[ $? != 0 ]] ; then
  echo "Install Apple command line tools? (Y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
    echo -ne "Installing Apple command line tools... "
      {
        xcode-select --install
      } &> /dev/null
    success
  fi
else
  warn "Apple command line tools are already installed!"
fi

# Homebrew
# -----------------------------------------------

echo
echo "Install Homebrew and all recipes, apps and fonts? (Y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then

  which -s brew
  if [[ $? != 0 ]] ; then
    echo -ne "Installing Homebrew... "
      {
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
      } &> /dev/null
    success
  else
    warn "Homebrew already installed!"
    echo -ne "Updating Homebrew recipes... "
      {
        brew update
      } &> /dev/null
    success
  fi

  echo -ne "Tapping... "
    {
      brew tap caskroom/versions
      brew tap caskroom/fonts
      brew tap igas/fry
    } &> /dev/null
  success

  echo -ne "Installing recipes... "
    {
      brew install the_silver_searcher
      brew install git
      brew install stow
      brew install ruby-install
      brew install postgres
      brew install fish
      brew install fry
      brew install caskroom/cask/brew-cask
    } &> /dev/null
  success

  echo -ne "Installing fonts... "
    {
      brew cask install font-office-code-pro
      brew cask install font-inconsolata
      brew cask install font-hack
      brew cask install font-input
    } &> /dev/null
  success

  echo -ne "Installing apps... "
    {
      brew cask install atom
      brew cask install spotify
      brew cask install alfred
      brew cask install sketch
      brew cask install cleanmymac
      brew cask install 1password
      brew cask install iterm2-beta
      brew cask install google-chrome
      brew cask install bartender
      brew cask install slack
      brew cask install rightfont
      brew cask install soundnode
    } &> /dev/null
  success

  echo -ne "Cleaning up... "
    {
      brew cleanup
      brew cask cleanup
    } &> /dev/null
  success
fi

echo

echo
echo "Install games and game utilities? (Y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then

  echo -ne "Installing apps... "
    {
      brew cask install league-of-legends
      brew cask install razer-synapse
    } &> /dev/null
  success

  echo -ne "Cleaning up... "
    {
      brew cleanup
      brew cask cleanup
    } &> /dev/null
  success
fi

echo

# SSH Keys
# -----------------------------------------------

if [[ -f ~/.ssh/id_rsa && -f ~/.ssh/id_rsa.pub ]] ; then
  warn "SSH keys have already been generated!"
  echo
else
  echo "Generate SSH keys? (Y/N)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
    echo "What is your email?"
    read EMAIL
    ssh-keygen -t rsa -b 4096 -C $EMAIL
    ssh-add ~/.ssh/id_rsa
  fi
  echo
fi

# Symlinks
# -----------------------------------------------

echo "Symlink dotfiles? (Y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then

  # OSX
  echo -ne "Linking /osx... "
    stow osx
  success

  # Fish
  echo -ne "Linking /fish... "
    stow fish
  success
  echo
fi

# iTerm
# -----------------------------------------------

echo "Configure iTerm2? (Y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
  echo -ne "Linking preferences... "
    defaults write com.googlecode.iterm2.plist -string "~/.dotfiles/iterm"
  success
fi
