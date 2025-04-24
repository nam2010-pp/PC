#!/data/data/com.termux/files/usr/bin/bash

# 1. Cập nhật và cài gói cần thiết
echo "[+] Cập nhật và cài gói..."
pkg update -y
pkg install -y x11-repo
pkg install -y tigervnc xfce4 xfce4-goodies firefox git python

# 2. Cài websockify qua pip
echo "[+] Cài websockify..."
pip install websockify

# 3. Clone noVNC (chỉ cần web assets)
echo "[+] Clone noVNC..."
git clone https://github.com/novnc/noVNC.git ~/noVNC

# 4. Cấu hình VNC (XFCE4)
echo "[+] Tạo ~/.vnc/xstartup..."
mkdir -p ~/.vnc
cat > ~/.vnc/xstartup <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
EOF
chmod +x ~/.vnc/xstartup

# 5. Khởi tạo VNC để tạo config rồi kill ngay
echo "[+] Khởi tạo VNC lần đầu..."
vncserver :1
sleep 2
vncserver -kill :1

# 6. Tạo icon Firefox trên desktop XFCE
echo "[+] Tạo icon Firefox trên Desktop..."
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

# 7. Khởi động lại VNC server
echo "[+] Khởi động VNC server..."
vncserver :1

# 8. Chạy noVNC bằng websockify module
echo "[+] Chạy noVNC (websockify)..."
DISPLAY=:1 python3 -m websockify --web ~/noVNC 6080 localhost:5901 &

# 9. Thông báo
echo
echo "✅ Hoàn thành! Mở trình duyệt vào:"
echo "   http://localhost:6080/vnc.html"
echo
echo "🛑 Để tắt:"
echo "   vncserver -kill :1"
echo "   pkill -f websockify"
echo
