# Guía de instalación
<img src="https://www.archlinux.org/static/logos/archlinux-logo-dark-90dpi.ebdee92a15b3.png"></img>
## Instalación del sistema
```bash
loadkeys es
```
### Particionamiento
Primero vamos a mirar la lista de discos y particiones del PC:
```bash
fdisk -l
```

Podemos particionar el sistema usando una de las siguientes herramientas. Véase que hay que proporcionar el disco a particionar, por ejemplo `/dev/sda`. Repetimos este proceso para todos los discos. Crearemos cuatro particiones, una de al menos 50GB para `/`, otra de 8GGB para `swap`, otra de `512MB` para `boot` y una última con todo el espacio que podamos para `home`. 
```bash
cfdisk [DISCO]
fdisk [DISCO]
```

Luego formateamos las particiones recién creadas con `mkfs`. Yo elijo normalmente separar `boot` y `home` de `/`. Todas las particiones contendrán sistemas `ext4` excepto por `boot`, que será de tipo `ext2`.
```bash
mkfs.ext4 [Partición /]
mkfs.ext4 [Partición home]
mkfs.ext2 [Partición boot]
mkswap [Partición swap]
```

Activamos el área de intercambio.
```bash
swapon [Partición swap]
```

Y montamos las particiones creadas.
```bash
mount [Partición /] /mnt
mkdir /mnt/home
mkdir /mnt/boot
mount [Partición home] /mnt
mount [Partición boot] /mnt
```

### Instalación de Linux
```bash
pacstrap /mnt base base-devel linux linux-config
pacstrap /mnt mesa mesa-demos xf86-video-? xf86-input-synaptics
pacstrap /mnt nvim sudo grub networkmanager
```

### Configuración del sistema    
```bash
arch-chroot /mnt    
```

```bash
echo "[hostname]" > /etc/hostname
ln -s /usr/share/zoneinfo/Europe/Madrid /etc/localtime
echo "es_ES.UTF-8 UTF-8" > /etc/locale.gen
echo "es_ES.UTF-8" > /etc/locale.conf
echo "KEYMAP=es" > /etc/vconsole.conf
locale-gen
hwclock --systohc
```

```bash
mkinitcpio -P
```

```bash
grub-install --target=x86_64-efi --efi-directory=/boot/grub/efi --bootloader-id=GRUB
grub-install --target=i386-pc [Partición boot]
```

```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

```bash
useradd -m -G wheel -s /bin/bash [USER]
nvim /etc/sudoers
passwd [USER]
```

```bash
exit
umount -R /mnt
reboot
```

#### Una última cosa...

```bash
sudo systemctl start NetworkManager
sudo systemctl enable NetworkManager
```

```bash
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

## Instalación del entorno de escritorio

```bash
sudo pacman -S xorg-xserver xorg-xinit
sudo pacman -S i3-gaps rofi nitrogen picom
echo "exec i3" > .xinitrc
```

```bash
yay -S polybar
```

### Aplicaciones importantes
```bash
sudo pacman -S terminator atom ranger pass xreader
```

### Navegadores 

Thomas Jefferson dijo "El sistema operativo es el bootloader del navegador web". Yo recomiendo los siguientes:
<img src="https://brave.com/wp-content/uploads/2019/01/logotype-full-color.svg"/>

```bash
yay -S brave-bin
```

<img src="https://www.chromium.org/_/rsrc/1438879449147/config/customLogo.gif?revision=3"/>

```bash
sudo pacman -S chromium
```

<img src="https://d33wubrfki0l68.cloudfront.net/06185f059f69055733688518b798a0feb4c7f160/9f07a/images/product-identity-assets/firefox.png"/>

```bash
sudo pacman -S firefox
```

## Configuración final

## Crontab
```bash
sudo pacman -S cronie
sudo crontab -e # @reboot pacman -Syy
```

### VPN
[TODO]

### Samba
```bash
mkdir /home/shared
sudo echo "//[IP]/[SHAREDIR]	/home/shared	cifs username=[UNAME],password=[PASS],uid=[LOCALUSER],gid=[LOCALGROUP]	0	2" >> /etc/fstab
sudo mount -a
```

### Copy config files

### Install oh-my-zsh
```bash
sudo pacman -S zsh
yay -S oh-my-zsh-git
sudo usermod -s /bin/zsh [USERNAME]
nvim .zshrc
```
