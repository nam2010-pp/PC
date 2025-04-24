#!/data/data/com.termux/files/usr/bin/bash

echo "[+] Cập nhật và cài gói cần thiết..."
pkg update -y
pkg install -y x11-repo
pkg install -y tigervnc xfce4 xfce4-goodies firefox git

echo "[+] Tạo file khởi động VNC với XFCE4..."
mkdir -p ~/.vnc
cat > ~/.vnc/xstartup <<EOF
#!/data/data/com.termux/files/usr/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
EOF
chmod +x ~/.vnc/xstartup

echo "[+] Khởi động VNC lần đầu..."
vncserver :1
sleep 2
vncserver -kill :1

echo "[+] Tạo icon Firefox trên Desktop..."
mkdir -p ~/.local/share/applications ~/Desktop

cat > ~/.local/share/applications/firefox.desktop <<EOF
[Desktop Entry]
Version=1.0
Name=Firefox
Comment=Trình duyệt web
Exec=firefox
Icon=firefox
Terminal=false
Type=Application
Categories=Network;WebBrowser;
EOF

cp ~/.local/share/applications/firefox.desktop ~/Desktop/
chmod +x ~/Desktop/firefox.desktop

echo "[+] Clone noVNC + websockify..."
git clone https://github.com/novnc/noVNC ~/noVNC
cd ~/noVNC
git clone https://github.com/novnc/websockify
cd ~

echo "[+] Khởi động lại VNC..."
vncserver :1

echo "[+] Mở noVNC proxy..."
cd ~/noVNC
DISPLAY=:1 ./utils/novnc_proxy --vnc localhost:5901 --listen 6080 &

echo
echo "[✓] XONG! Mở trình duyệt vào link sau:"
echo "    http://localhost:6080/vnc.html"
echo
echo "[!] Tắt bằng:"
echo "    vncserver -kill :1 && pkill -f novnc_proxy"
