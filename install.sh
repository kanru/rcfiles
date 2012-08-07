#!/bin/sh

## Link the config files to home directory

SCRIPT=`readlink -f $0`
SCRIPTPATH=`dirname $SCRIPT`
git=$SCRIPTPATH

cd ~

# zsh
ln -fs $git/zsh/zsh       .zsh
ln -fs $git/zsh/zshrc     .zshrc
ln -fs $git/zsh/zshenv    .zshenv
ln -fs $git/zsh/zshalias  .zshalias
ln -fs $git/zsh/zshhashes .zshhashes

# others
ln -fs $git/Xresources .Xresources
ln -fs $git/cvsrc      .cvsrc
ln -fs $git/devscripts .devscripts
ln -fs $git/fonts.conf .fonts.conf
ln -fs $git/gitconfig  .gitconfig
ln -fs $git/hgrc       .hgrc
ln -fs $git/nethackrc  .nethackrc
ln -fs $git/quiltrc    .quiltrc
