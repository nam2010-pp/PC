#!/data/data/com.termux/files/usr/bin/bash

# 👉 1. Cập nhật & cài essentials
pkg update -y
pkg install -y x11-repo
pkg install -y tigervnc xfce4 xfce4-goodies firefox git openssl python

# 👉 2. Thiết lập VNC với XFCE4
mkdir -p ~/.vnc
cat > ~/.vnc/xstartup <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
EOF
chmod +x ~/.vnc/xstartup

# Nếu đang có server cũ thì kill
vncserver -kill :1 &>/dev/null || true

# Khởi tạo VNC lần đầu để tạo config, rồi kill để reset
vncserver :1
sleep 2
vncserver -kill :1

# 👉 3. Clone noVNC full repo + websockify
git clone https://github.com/novnc/noVNC.git ~/noVNC-full
cd ~/noVNC-full
git submodule update --init --recursive

# 👉 4. Tạo SSL self-signed (cho wss://)
mkdir -p ~/.vnc
openssl req -new -x509 -nodes -days 365 \
  -subj "/C=VN/ST=VN/L=Hanoi/O=Termux/CN=localhost" \
  -out ~/.vnc/novnc.crt -keyout ~/.vnc/novnc.key

# 👉 5. (Optional) HTTP basic auth: sửa user/password nếu muốn
# htpasswd -bc ~/.vnc/passwd remoteuser somepassword

# 👉 6. Khởi động VNC server chính
vncserver :1

# 👉 7. Chạy noVNC proxy với đầy đủ tùy chọn
cd ~/noVNC-full/utils
DISPLAY=:1 python3 novnc_proxy \
  --vnc localhost:5901 \
  --listen 6080 \
  --cert ~/.vnc/novnc.crt \
  --key ~/.vnc/novnc.key \
  --ssl-only \
  --record \
  --idle-timeout 300000 \
  --heartbeat 30 &

# 👉 8. Tạo icon Firefox Desktop
mkdir -p ~/.local/share/applications ~/Desktop
cat > ~/.local/share/applications/firefox.desktop <<'EOF'
[Desktop Entry]
Version=1.0
Name=Firefox
Comment=Web Browser
Exec=firefox %u
Icon=firefox
Terminal=false
Type=Application
Categories=Network;WebBrowser;
EOF
cp ~/.local/share/applications/firefox.desktop ~/Desktop/
chmod +x ~/Desktop/firefox.desktop

# 👉 9. In thông tin truy cập
echo
echo "🔥 XFCE4 + Firefox + full noVNC đã sẵn sàng! 🔥"
echo "   ▶ VNC display :1 -> localhost:5901"
echo "   ▶ noVNC (secure): https://localhost:6080/vnc.html"
echo "   ▶ SSL cert/key ở ~/.vnc/novnc.{crt,key}"
echo
echo "🛑 Dừng mọi thứ: vncserver -kill :1 && pkill -f novnc_proxy"
echo
