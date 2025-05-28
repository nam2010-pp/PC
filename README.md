# Setup giao diện XFCE4 + VNC + Firefox trên Termux (không root)🛠️

Đây là hướng dẫn cài giao diện Linux (XFCE4) trên Termux bằng VNC. Hỗ trợ chạy Firefox và phần mềm có giao diện GUI khác. Không cần root máy.

---

## Yêu cầu😈

- Cài Termux từ F-Droid(https://f-droid.org/packages/com.termux/) hoặc googleplay
- Có mạng ổn định
- Android chưa root cũng chạy được

---

## Cách cài đặt👻

### 1. Mở Termux và chạy lệnh sau:

pkg update && pkg upgrade -y
pkg install wget -y
wget https://raw.githubusercontent.com/nam2010-pp/PC/main/termux.sh
bash termux.sh

Mở giao diện
Cài ứng dụng VNC Viewer trên CH Play

Mở VNC Viewer, bấm dấu+ nhập localhost:1
Bấm "Create", sau đó "Connect"

Nhập mật khẩu (do bạn đặt lúc chạy vncserver :1 lần đầu)
Tắt giao diện
Để tắt vncserver nhập:     vncserver -kill :1
*Ghi chú*
Firefox sẽ có sẵn trên Desktop sau khi chạy xong.
Tác giả🛠️
Script bởi Nam.
Dành cho ai thích nghịch Termux, máy ảo, giao diện Linux không cần root.
