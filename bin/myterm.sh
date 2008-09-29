#!/bin/sh
#urxvt -fn "xft:Monaco:pixelsize=15,xft:DFLiHei Std W5:pixelsize=17,xft:Microsoft YaHei:pixelsize=20" +sb -cr red -pt Root -rv $@
#gnome-terminal $@
export TERM=gnome
exec roxterm $@
