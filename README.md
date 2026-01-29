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
### `echo "user-agent=\"WINK/1.75.1 (AndroidTV/9) HlsWinkPlayer\"" > ~/.config/mpv/mpv.conf`
## устновить приложение:
### `sudo wget https://raw.githubusercontent.com/shahin8r/iptv/master/iptv -qO /usr/local/bin/iptv && sudo chmod +x /usr/local/bin/iptv; echo -e "echo\nps aux | grep -i 'mpv\|iptv'" | sudo tee -a /usr/local/bin/iptv`
## подгрузить плейлист:
### `iptv https://raw.githubusercontent.com/gnomba/iptv/main/Playlist.m3u`
## запустить:
### `iptv`

# m3u.su
## BASH
### `for vNUM in $(curl -s https://m3u.su/ | grep page-link | sed -e 's/<[^>]*>//g' | awk '{print $1}'); do for vFILE in $(curl -s https://m3u.su/page/${vNUM} | grep 'm3u.su/'); do wget -q --show-progress -c ${vFILE}.m3u; done; done`
## POWERSHELL
### `$fileNames = (Get-ChildItem -File *.m3u | ForEach-Object {$_.Name}); $fileNames.Length`
### `$fileNames | ForEach-Object {./iptv-m3u-checker.ps1 "$_"}`
