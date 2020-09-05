# Guía de instalación
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
mkfs.ext4 /dev/sd[LETRA de home][NUMERO de home]
mkfs.ext4 /dev/sd[LETRA de /][NUMERO de /]
mkfs.ext4 /dev/sd[LETRA de boot][NUMERO de boot]
mkswap /dev/sd[LETRA de swap][NUMERO de swap]
```

Activamos el área de intercambio.
```bash
swapon /dev/sd[LETRA de swap][NUMERO de swap]
```

Y montamos las particiones creadas.
```bash
mount /dev/sd[LETRA de /][NUMERO de /] /mnt
mkdir /mnt/home
mkdir /mnt/boot
mount /dev/sd[LETRA de home][NUMERO de home] /mnt
mount /dev/sd[LETRA de boot][NUMERO de boot] /mnt
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
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-install --target=i386-pc /dev/sd[letra]
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
yay -S brave
sudo pacman -S terminator atom ranger pass xreader
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
