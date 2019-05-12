FROM ubuntu:18.04

# 系統語系
ARG lang=zh_TW
#ARG lang=zh_CN
#ARG lang=en_US

RUN apt-get update && \
	apt-get install -y \
		wget \
		vim \
		# virtual framebuffer X server for X Version 11
		xvfb \
		# Terminal
		gnome-terminal \
		# VNC server
		x11vnc \
	       # fcitx 輸入法系統
		fcitx-bin \
		fcitx-table \
		dbus-x11 \
		# 倉頡輸入法
		fcitx-table-cangjie5 \
		# 新酷音輸入法
		fcitx-chewing \
		# 無蝦米輸入法
		fcitx-table-boshiamy \
		# 日文輸入法
		fcitx-anthy \
		# google拼音
		fcitx-googlepinyin \
	       # 拼音
		fcitx-pinyin \
		fcitx-sunpinyin \
		# 中文字型，中文語系翻譯
		language-pack-zh-han* \
		fonts-wqy-* \
		locales && \
	locale-gen en_US.UTF-8 && \
	locale-gen zh_TW.UTF-8 && \
	locale-gen zh_CN.UTF-8

#
# 設定輸入法預設切換熱鍵 SHIFT-SPACE
#
RUN mkdir -p /root/.config/fcitx && \
	echo [Hotkey] > /root/.config/fcitx/config && \
	echo TriggerKey=SHIFT_SPACE >> /root/.config/fcitx/config \
	echo SwitchKey=Disabled >> /root/.config/fcitx/config \
	echo IMSwitchKey=False >> /root/.config/fcitx/config

#
# Install openbox - window manager
#

RUN apt-get install -y openbox
COPY src/etc/openbox/ /etc/openbox/

#
# Install tint2 - taskbar for X11
#

RUN apt-get install -y tint2
COPY src/etc/tint2/tint2rc /etc/tint2/tint2rc

#
# Install noVNC
#

RUN apt-get install -y net-tools git && \
	git clone https://github.com/novnc/noVNC.git /usr/noVNC/ && \
	git clone https://github.com/novnc/websockify /usr/noVNC/utils/websockify
COPY src/index.html /usr/noVNC/index.html

#
# Download JDownloader.
#

RUN wget -q http://installer.jdownloader.org/JDownloader.jar -P /usr/jd2/
COPY src/JDownloader2.png /usr/jd2/JDownloader2.png
COPY src/JDownloader2.desktop /usr/share/applications/JDownloader2.desktop
COPY src/org.jdownloader.captcha.v2.solver.browser.BrowserCaptchaSolverConfig.browsercommandline.json /usr/jd2/
COPY src/org.jdownloader.settings.GeneralSettings.browsercommandline.json /usr/jd2/

#
# Install Java SE Runtime Environment 8u192 (Linux 64)
# https://download.oracle.com/otn-pub/java/jdk/8u192-b12/750e1c8617c5452694857ad95c3ee230/jre-8u192-linux-x64.tar.gz
#

COPY src/jre-8u192-linux-x64.tar.gz /tmp
RUN mkdir -p /usr/jre && \
	tar zxvf /tmp/jre-8u192-linux-x64.tar.gz -C /usr/jre && \
	update-alternatives --install /usr/bin/java java /usr/jre/jre1.8.0_192/bin/java 20000 && \
	rm -r /tmp/jre-8u192-linux-x64.tar.gz

#
# Download CHROME
#
RUN apt-get install -y gnupg && \
	wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
	echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
	apt-get update && \
	apt-get install -y google-chrome-stable && \
	rm -f /etc/apt/sources.list.d/google.list
COPY src/google-chrome.desktop /usr/share/applications/
RUN xdg-settings set default-web-browser google-chrome.desktop

#
# Install supervisor - process control system
#
RUN apt-get install -y supervisor
COPY src/etc/supervisor/  /etc/supervisor/

# install gedit text editor
RUN apt-get install -y gedit gedit-common
#COPY src/gedit.desktop /usr/share/applications/

#
# Default download folder
#
RUN mkdir -p /root/Downloads && \
	ln -s /root/Downloads /dl

# Setup environment variables
ENV \
	# 時區
	TZ=Asia/Taipei \
	# 系統語系
	LANG=$lang.UTF-8 \
	LANGUAGE=$lang \
	LC_ALL=$lang.UTF-8 \
	# 輸入法
	XMODIFIERS="@im=fcitx" \
	GTK_IM_MODULE=fcitx \
	QT_IM_MODULE=fcitx \
	#
	DISPLAY=:0 \
	NOVNC_PORT=5800 \
	VNC_PORT=5900 \
	VNC_PW=vncpwd \
	RESOLUTION=1280x768x16 \
	JDOWNLOADER2_AUTO_START=yes \
	JDOWNLOADER2_AUTO_RESTART=no

EXPOSE 5800 5900

VOLUME ["/dl", "/usr/jd2/cfg"]

COPY src/bootstrap.sh /
RUN chmod 755 /bootstrap.sh
CMD ["/bootstrap.sh"]


