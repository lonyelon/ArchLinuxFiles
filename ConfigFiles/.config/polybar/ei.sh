# change to home dir
cd $HOME

# clone this repo
git clone https://github.com/adi1090x/polybar-themes

# go to polybar-1 dir
cd polybar-themes/polybar-1

# copy fonts to local fonts dir (i'll put the fonts in all dirs)
cp -r fonts/* ~/.local/share/fonts

# reload font cache
fc-cache -v

# copy everything from polybar-1 to polybar config dir (backup your config first if you have)
cp -r * ~/.config/polybar

# run launch.sh 
~/.config/polybar/launch.sh
