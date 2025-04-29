#!/bin/bash

echo "[+] Cài gói cần thiết..."
apt update && apt install -y \
    xfce4 xfce4-goodies tightvncserver x11vnc \
    xterm novnc websockify curl wget xvfb sudo

echo "[+] Cài Cloudflared..."
wget -O cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
chmod +x cloudflared
mv cloudflared /usr/local/bin/cloudflared

echo "[+] Fix user info nếu thiếu..."
grep -q "^root:" /etc/passwd || echo "root:x:0:0:root:/root:/bin/bash" >> /etc/passwd

export USER=root
export HOME=/root
mkdir -p ~/.vnc

echo "[+] Đặt mật khẩu VNC..."
echo "123456" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

echo "[+] Tạo file xstartup không dùng xrdb..."
cat > ~/.vnc/xstartup <<EOF
#!/bin/bash
export DISPLAY=:1
startxfce4 &
EOF
chmod +x ~/.vnc/xstartup

echo "[+] Tạo script khởi động GUI và Cloudflared..."
cat > ~/start_gui.sh <<EOF
#!/bin/bash
export DISPLAY=:1
export USER=root
export HOME=/root

# Chạy Xvfb
Xvfb :1 -screen 0 1024x768x24 &
sleep 2

# Chạy VNC server ở display :19 => port 5919
vncserver :19
x11vnc -display :19 -nopw -forever -bg

# noVNC qua websockify
websockify --web=/usr/share/novnc/ 8080 localhost:5919 &

# Tạo tunnel Cloudflare
echo "[+] Đang khởi chạy Cloudflared Tunnel..."
cloudflared tunnel --url http://localhost:8080 --no-autoupdate
EOF

chmod +x ~/start_gui.sh

echo "[✓] Xong rồi! Chạy GUI bằng lệnh:"
echo "    bash ~/start_gui.sh"
