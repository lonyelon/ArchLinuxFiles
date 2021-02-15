# Personalización de navegadores

En este fichero se describe en detalle cómo configuro mis navegadores.

## Librewolf

1. Poner el tema oscuro y la interfaz en `compacto`.
2. En uBlock marcar `Prevent WebRTC from leaking local IP addresses` para impedir que *WebRTC* filtre direcciones IP locales a los sitios que visitamos.
3. Instalar el addon de KeepassXC.
4. En las opciones del navegador permitir conservar cookies, datos, historial... etc tras cerrar el navegador.
5. (Opcional) Instalar *Tridactyl* para tener combinaciones de teclas Vim-like.
  a. Si hiciste lo anterior, añade las siguientes líneas al fichero `~/.librewolf/[perfil]/chrome/userChrome.css`, donde `[profile]` es tu perfil: 
  ```css
  #TabsToolbar { visibility: collapse !important; }
  #back-button, #forward-button { display:none!important; }
  ```

## Brave

Ya haré esta lista pero básicamente: poner el tema oscuro, desactivar *Brave rewards* y el cliente torrent, instalar y configurar *uBlock Origin*... etc.
