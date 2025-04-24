#!/data/data/com.termux/files/usr/bin/bash

echo "[+] Cập nhật và cài gói..."
pkg update -y && pkg upgrade -y
pkg install -y x11-repo
pkg install -y tigervnc xfce4 xfce4-goodies firefox git

echo "[+] Clone noVNC (chạy không dùng websockify)..."
git clone https://github.com/novnc/noVNC.git ~/noVNC-full
chmod +x ~/noVNC-full/utils/novnc_proxy

echo "[+] Cấu hình VNC cho XFCE4..."
mkdir -p ~/.vnc
cat > ~/.vnc/xstartup <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
EOF
chmod +x ~/.vnc/xstartup

echo "[+] Khởi tạo VNC lần đầu..."
vncserver :1
sleep 2
vncserver -kill :1

echo "[+] Tạo icon Firefox..."
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

echo "[+] Khởi động lại VNC..."
vncserver :1

echo "[+] Mở noVNC (dùng script proxy của noVNC)..."
DISPLAY=:1 ~/noVNC-full/utils/novnc_proxy --vnc localhost:5901 --listen 6080 &

echo
echo "✅ DONE! Truy cập tại: http://localhost:6080/vnc.html"
echo "🛑 Để tắt:"
echo "   vncserver -kill :1"
echo "   pkill -f novnc_proxy"
echo
