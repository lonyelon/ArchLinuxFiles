#!/bin/bash

FILES=(
	.aliases
	.zshrc
	.config/i3
	.config/nvim
	.config/picom
	.config/polybar
	.config/ranger
	.config/rofi
	.config/terminator
	.mutt
)

FILESFOLDER=ConfigFiles

rm -rf ./$FILESFOLDER

[[ ! -d $FILESFOLDER ]] && mkdir $FILESFOLDER
[[ ! -d $FILESFOLDER/.config ]] && mkdir $FILESFOLDER/.config

for f in ${FILES[@]}; do
	[[ "$f" =~ "^\.config" ]] && cp -r ~/$f ./$FILESFOLDER/$f || cp -r ~/$f ./$FILESFOLDER/$f
done

sed -r -i "s/^(set imap_user = )\"[A-Za-z0-9\.@]+\"/\1\"\"/g" ./$FILESFOLDER/.mutt/muttrc
sed -r -i "s/^(set imap_pass = )\"[A-Za-z0-9\.@]+\"/\1\"\"/g" ./$FILESFOLDER/.mutt/muttrc
sed -r -i "s/^(set realname = )\"[A-Za-z0-9\.@\ ]+\"/\1\"\"/g" ./$FILESFOLDER/.mutt/muttrc
