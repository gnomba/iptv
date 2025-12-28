# RU:
### https://raw.githubusercontent.com/gnomba/iptv/main/Playlist.m3u

# NZ:
### https://i.mjh.nz/

# CLI
## установить зависимости:
### `curl fzf mpv`
## поднастроить mpv:
### `mkdir -pv ~/.config/mpv/`
### `> ~/.config/mpv/mpv.conf`
### `echo "user-agent=\"WINK/1.74.2 (AndroidTV/9) HlsWinkPlayer\"" > ~/.config/mpv/mpv.conf`
## устновить приложение:
### `sudo wget https://raw.githubusercontent.com/shahin8r/iptv/master/iptv -qO /usr/local/bin/iptv && sudo chmod +x /usr/local/bin/iptv; echo -e "echo\nps aux | grep -i 'mpv\|iptv'" | sudo tee -a /usr/local/bin/iptv`
## подгрузить плейлист:
### `iptv https://raw.githubusercontent.com/gnomba/iptv/main/Playlist.m3u`
## запустить:
### `iptv`
