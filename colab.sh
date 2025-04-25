#!/bin/bash
export USER=$(whoami)
echo "[+] Cài gói cần thiết..."
apt update && apt install -y xfce4 xfce4-goodies tightvncserver x11vnc firefox xterm wget unzip curl

echo "[+] Cài noVNC và Websockify..."
mkdir -p ~/novnc
cd ~/novnc
wget https://github.com/novnc/noVNC/archive/refs/heads/master.zip
unzip master.zip && mv noVNC-master/* . && rm -rf noVNC-master master.zip
git clone https://github.com/novnc/websockify
cd ~

echo "[+] Tạo ~/.vnc/xstartup cho XFCE4..."
mkdir -p ~/.vnc
cat > ~/.vnc/xstartup <<EOF
#!/bin/bash
xrdb \$HOME/.Xresources
startxfce4 &
EOF
chmod +x ~/.vnc/xstartup

echo "[+] Tạo icon Firefox..."
mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/firefox.desktop <<EOF
[Desktop Entry]
Version=1.0
Name=Firefox
Exec=firefox %u
Icon=firefox
Terminal=false
Type=Application
Categories=Network;WebBrowser;
EOF
chmod +x ~/.local/share/applications/firefox.desktop

echo "[+] Start VNC với :19..."
vncserver :19 && vncserver -kill :19

echo "[+] Cài cloudflared..."
wget -O cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
dpkg -i cloudflared.deb || apt --fix-broken install -y && dpkg -i cloudflared.deb
rm cloudflared.deb

echo "[+] Chạy x11vnc + websockify + cloudflared..."
DISPLAY=:19 x11vnc -display :19 -rfbport 5919 -forever -nopw -bg
~/novnc/websockify/run 8080 localhost:5919 &

echo "[+] Mở Cloudflared Tunnel..."
cloudflared tunnel --url http://localhost:8080 --no-autoupdate
