@powershell -NoProfile -ExecutionPolicy unrestricted -Command "(iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))) >$null 2>&1" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
cinst -y chocolateygui
cinst -y cygwin
cinst -y git.install
cinst -y Mercurial
cinst -y 7zip.commandline
cinst -y Python2.x
cinst -y ruby
cinst -y nodejs
cinst -y SourceCodeProFont
cinst -y RobotoFont
cinst -y vlc
cinst -y Atom
cinst -y keepass.install
cinst -y DotNet4.5
cinst -y Dropbox
cinst -y virtualbox
cinst -y jdk8
cinst -y jdk7
cinst -y Firefox
cinst -y synergy
cinst -y intellijidea-community
cinst -y gradle
cinst -y optipng
cinst -y imagemagick
cinst -y graphviz
cinst -y ffmpeg
cinst -y wireshark
cinst -y burp-proxy-free-edition
cinst -y curl
cinst -y youtube-dl
cinst -y rtmpdump
cinst -y obs
cinst -y teamspeak
cinst -y steam
cinst -y osu
cinst -y adobe-creative-cloud
cinst -y Quicktime
cinst -y opencodecs
cinst -y lame
cinst -y mp3gain
cinst -y ag
cinst -y win32-openssh
