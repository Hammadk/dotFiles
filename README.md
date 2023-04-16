This is a copy of Hammad's dotfiles. Running `home/bootstrap.sh` creates new symlinks in the `$HOME` folder for all files and folders in `/home`. Files and folders that you wish to symlink must start with a `.`

### Usage:

``` sh
cd ~
git clone https://github.com/Hammadk/dotFiles.git
cd dotFiles
sh bootstrap.sh
```

Once `bootstrap.sh` is run, you'll see output that looks like:
-e ~/.inputrc does not exist. Symlinking to dotfile.
-e ~/.irbrc is symlinked to your dotfiles.
-e ~/.tmux-mac.conf is symlinked to your dotfiles.
```

Mac Requirement:

``` sh
brew install tmux
brew install reattach-to-user-namespace # needed for Tmux

# Dependency for AG
brew install the_silver_searcher

# Fuzzy search for vim
brew install fzf
```

Mac nice-to-haves:
```
1. Install Terminal themes in dotfiles/themes
2. Install Fonts from dotfiles/fonts
```

Vim installation:
```
:PlugInstall
```

Vscode installation:
```
1. Copy vscode/public-keybindings.json
2. Copy vscode/public-user-settings.json
```
