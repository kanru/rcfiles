#!/bin/sh

## Link the config files to home directory

SCRIPT=`readlink -f $0`
SCRIPTPATH=`dirname $SCRIPT`
git=$SCRIPTPATH

cd ~

# zsh
ln -bs $git/zsh/zsh       .zsh
ln -bs $git/zsh/zshrc     .zshrc
ln -bs $git/zsh/zshenv    .zshenv
ln -bs $git/zsh/zshalias  .zshalias
ln -bs $git/zsh/zshhashes .zshhashes

# others
ln -bs $git/Xresources .Xresources
ln -bs $git/cvsrc      .cvsrc
ln -bs $git/devscripts .devscripts
ln -bs $git/dir_colors .dir_colors
mkdir -p .config/fontconfig
ln -bs $git/fonts.conf .config/fontconfig/fonts.conf
ln -bs $git/gitconfig  .gitconfig
ln -bs $git/hgrc       .hgrc
ln -bs $git/nethackrc  .nethackrc
ln -bs $git/quiltrc    .quiltrc
ln -bs $git/stumpwmrc  .stumpwmrc
