FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y && \
    apt install -y xfce4 xfce4-goodies tightvncserver novnc websockify \
    wget curl git sudo python3 python3-pip net-tools x11vnc xterm

# Tạo user mới không cần password
RUN useradd -m user && echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER user
WORKDIR /home/user

# Thiết lập VNC
RUN mkdir -p ~/.vnc
RUN echo "#!/bin/bash\nstartxfce4 &" > ~/.vnc/xstartup && \
    chmod +x ~/.vnc/xstartup && \
    vncserver :1 && \
    vncserver -kill :1

EXPOSE 8080

CMD x11vnc -display :1 -forever -nopw -shared -bg && \
    websockify --web=/usr/share/novnc/ 8080 localhost:5901
