#!/data/data/com.termux/files/usr/bin/bash

echo "[+] Cập nhật và cài gói cần thiết..."
pkg update -y && pkg upgrade -y
pkg install -y x11-repo
pkg install -y tigervnc xfce4 xfce4-goodies firefox git wget
echo "[+] Cấu hình VNC và XFCE4..."
mkdir -p ~/.vnc
cat > ~/.vnc/xstartup <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
EOF
chmod +x ~/.vnc/xstartup

echo "[+] Khởi tạo VNC lần đầu..."
vncserver :1
sleep 10
vncserver -kill :1

echo "[+] Tải icon Firefox..."
mkdir -p ~/.icons
wget -O ~/.icons/firefox.png https://upload.wikimedia.org/wikipedia/commons/thumb/a/a0/Firefox_logo%2C_2019.svg/1280px-Firefox_logo%2C_2019.svg.png

echo "[+] Tạo icon Firefox trên Desktop..."
mkdir -p ~/.local/share/applications ~/Desktop
cat > ~/.local/share/applications/firefox.desktop <<EOF
[Desktop Entry]
Version=1.0
Name=Firefox
Comment=Web Browser
Exec=firefox
Icon=$HOME/.icons/firefox.png
Terminal=false
Type=Application
Categories=Network;WebBrowser;
EOF
cp ~/.local/share/applications/firefox.desktop ~/Desktop/
chmod +x ~/Desktop/firefox.desktop

echo "[+] Khởi động lại VNC..."
vncserver :1

echo "[+] mở display"
DISPLAY=:1 1080x720
echo
echo "✅ XONG! Truy cập giao diện tại:"
echo
echo "🛑 Để tắt:"
echo "    vncserver -kill :1
echo
