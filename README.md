# Guía de instalación
<img src="https://www.archlinux.org/static/logos/archlinux-logo-dark-90dpi.ebdee92a15b3.png"></img>

En la siguiente guía pretendo anotar el proceso completo de instalación de Arch Linux que he ido perfeccionando con el paso de los años. No es la mejor forma ni la más rápida, pero es la manera que deja el sistema tal y como *yo* quiero. Este repositorio actúa entonces como un bloc de notas personal más que como una guía de instalación. Si alguien quiere personalizar mucho más el sistema de lo que aquí se enseña o aprender a instalarlo por primera vez, lo mejor es siempre consultar la <a href="https://wiki.archlinux.org/index.php/Installation_guide"> guía de instalación oficial </a>.
## Instalación del sistema
El primer paso es siempre poner el teclado en español por comodidad (esto sólo cambia el mapa de teclas durante la instalación):
```bash
loadkeys es
```
### Particionamiento
Antes de particionar vamos a mirar la lista de discos y particiones del PC:
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
mount [Partición home] /mnt/home
mount [Partición boot] /mnt/boot
```

### Instalación de Linux
Empleamos `pacstrap` para instalar los paquetes básicos del sistema. `xf86-video-?` se refiere a los drivers de video. Si se tiene una gráfica de AMD habrá que emplear `xf86-video-amdgpu`, para nvidia `xf86-video-nouveau` (o `nvidia` y `nvidia-utils` para los drivers propietarios) y para intel `xf86-video-intel`.
```bash
pacstrap /mnt base base-devel linux linux-config
pacstrap /mnt os-prober wpa_supplicant
pacstrap /mnt mesa mesa-demos xf86-video-? xf86-input-synaptics
pacstrap /mnt nvim sudo grub networkmanager
```

### Configuración del sistema    
Entramos al sistema recién instalado.
```bash
arch-chroot /mnt    
```

Le ponemos un nombre al equipo, establecemos la hora a la madrileña y configuramos el sistema para que esté en español.
```bash
echo "[hostname]" > /etc/hostname
ln -s /usr/share/zoneinfo/Europe/Madrid /etc/localtime
echo "es_ES.UTF-8 UTF-8" > /etc/locale.gen
echo "es_ES.UTF-8" > /etc/locale.conf
echo "KEYMAP=es" > /etc/vconsole.conf
locale-gen
hwclock --systohc
```

Creamos el *initcpio* del sistema.
```bash
mkinitcpio -P
```

Instalamos el cargador de arranque `grub`. Tenemos dos opciones, para sistemas EFI (la primera) y LEGACY (la segunda).
```bash
grub-install --target=x86_64-efi --efi-directory=/boot/grub/efi --bootloader-id=GRUB
grub-install --target=i386-pc [Partición boot]
```

Creamos la configuración de grub.
```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

Añadimos un usuario y lo añadimos a sudoers descomentando `%wheel ALL=(ALL) ALL` en el fichero.
```bash
useradd -m -G wheel -s /bin/bash [USER]
nvim /etc/sudoers
passwd [USER]
```

Cerramos y reiniciamos.
```bash
exit
umount -R /mnt
reboot
```

#### Una última cosa...

Tras el reinicio activamos el servicio de `NetworkManager`. Si vamos a emplear WiFi, tendremos el comando `nmtui` que nos permitirá elegir la red y poner la contraseña de forma fácil.
```bash
sudo systemctl start NetworkManager
sudo systemctl enable NetworkManager
```

Con la conexión establecida descargamos `yay` del AUR, que nos permitirá descargar paquetes del mismo fácilmente.
```bash
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

## Instalación del entorno de escritorio

Instalamos el servidor de `X` y el gestor de ventanas `i3` junto con todo el software necesario: `picom` para el compositor (transparencia), `rofi` para el menú de selección de programas, `nitrogen` para poner el fondo de escritorio y `polybar` para la barra de tareas. 
```bash
sudo pacman -S xorg-xserver xorg-xinit
sudo pacman -S i3-gaps rofi nitrogen picom
yay -S polybar
```

Por último añadimos unas líneas a `.xinitrc` que dejan el ratón tal y como quiero y después arrancan el entorno de escritorio tras el comando `startx`.
```
echo "xinput --set-prop 9 'libinput Accel Speed' -0.5" > .xinitrc
echo "exec i3" >> .xinitrc
```

### Aplicaciones importantes
Adjunto unas de las aplicaciones que más uso con el sistema.
```bash
sudo pacman -S terminator atom ranger pass xreader
```

### Navegadores 

Thomas Jefferson dijo "El sistema operativo es el bootloader del navegador web". Yo recomiendo los siguientes:

#### Brave
```bash
yay -S brave-bin
```

#### Chromium
```bash
sudo pacman -S chromium
```

#### Firefox
```bash
sudo pacman -S firefox
```

### Copiar archivos de configuración
En este repositorio se proporcionan dos carpetas, `config` y `fonts`. El contenido de la primera ha de copiarse a `~/.config` y el de la segunda a `~/.local/share/fonts` (si no existe se debe crearla primero con `mkdir ~/.local/share/fonts`).

## Configuración final

El sistema ya es funcional, pero está sin configurar. Vamos a dejarlo bonito.

### Crontab
Instalamos `crontab` y escribimos la línea `@reboot pacman -Syy`. Esto hará que arch actualice la lista de paquetes cada vez que el equipo se reinicie.
```bash
sudo pacman -S cronie
sudo crontab -e
```

### Samba
Yo tengo un servidor samba, así que dejo también la forma con la que hago que los archivos se compartan entre mis dos equipos.
```bash
mkdir /home/shared
sudo echo "//[IP]/[SHAREDIR]	/home/shared	cifs username=[UNAME],password=[PASS],uid=[LOCALUSER],gid=[LOCALGROUP]	0	2" >> /etc/fstab
sudo mount -a
```

### Instalar oh-my-zsh
```bash
sudo pacman -S zsh
yay -S oh-my-zsh-git
sudo usermod -s /bin/zsh [USERNAME]
nvim .zshrc
```

### VPN

