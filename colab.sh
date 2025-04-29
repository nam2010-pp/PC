#!/bin/bash

echo "[+] Cài gói cần thiết..."
apt update && apt install -y \
    xfce4 xfce4-goodies tightvncserver x11vnc \
    xterm novnc websockify curl wget xvfb

echo "[+] Cài Cloudflared..."
wget -O cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
chmod +x cloudflared
mv cloudflared /usr/local/bin/cloudflared

echo "[+] Tạo thư mục VNC..."
mkdir -p ~/.vnc

echo "[+] Đặt mật khẩu VNC (mặc định: 123456)..."
echo "123456" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

echo "[+] Tạo file xstartup (không dùng xrdb)..."
cat > ~/.vnc/xstartup <<EOF
#!/bin/bash
export DISPLAY=:1
startxfce4 &
EOF
chmod +x ~/.vnc/xstartup

echo "[+] Tạo script khởi động GUI + Cloudflared..."
cat > ~/start_gui.sh <<EOF
#!/bin/bash
export DISPLAY=:1
Xvfb :1 -screen 0 1024x768x24 &
sleep 2
vncserver :1
x11vnc -display :1 -nopw -forever -bg
websockify --web=/usr/share/novnc/ 8080 localhost:5901 &

echo "[+] Đang khởi chạy Cloudflared Tunnel..."
cloudflared tunnel --url http://localhost:8080 --no-autoupdate
EOF
chmod +x ~/start_gui.sh

echo "[✓] Setup xong rồi! Bấm chạy: bash ~/start_gui.sh"
