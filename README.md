# chrome-jdownloader2





## 主要功能

- JDownloader2

- Google CHROME browser

- Gui Text Editor (edit)

- VNC support

- noVNC (WEB base VNC) support

- 支援中文環境 (繁中/簡中) 與中文輸入法 (倉頡/新酷/無蝦米/google拼音/拼音/sunpinyin)



## 注意事項

- 預設使用者 root

- 不支援 SSL

- 在 Synology DSM 6.2 上測試
- 中文輸入法預設切換熱鍵 Shift-Space



## 連線方式

瀏覧器：  http://your_domain:5800

VPN客戶端： your_domain:5900



## 使用的套件

- x11vnc
- noVNC
- supervisor
- Xvfb
- openbox
- tint2
- jdownloader2
- google-chrome-stable
- fcitx
- gnome-terminal
- Edit



## 環境變數

|                      變數 | 說明                  | 預設        | 可設參數                                                     |
| ------------------------: | --------------------- | ----------- | ------------------------------------------------------------ |
|                      LANG | 系統語系設定          | zh_TW       | zh_TW \| zh_CN \| en_US                                      |
|                  LANGUAGE | 系統語系設定          | zh_TW       | zh_TW \| zh_CN \| en_US                                      |
|                    LC_ALL | 系統語系設定          | zh_TW       | zh_TW \| zh_CN \| en_US                                      |
|                        TZ | 時區                  | Asia/Taipei | [時區列表](http://manpages.ubuntu.com/manpages/bionic/man3/DateTime::TimeZone::Catalog.3pm.html) |
|                XMODIFIERS | 輸入法使用            | "@im=fcitx" | 請勿變更                                                     |
|             GTK_IM_MODULE | 輸入法使用            | fcitx       | 請勿變更                                                     |
|              QT_IM_MODULE | 輸入法使用            | fcitx       | 請勿變更                                                     |
|               NOVNC_PORT | noVNC port            | 5800        | 任意可用 port                                                |
|                  VNC_PORT | VNC port              | 5900        | 任意可用 port                                                |
|                    VNC_PW | 連線密碼              | vncpwd      | 空白表示不設密碼                                             |
|                RESOLUTION | 虛擬螢幕解析度        | 1280x768x16 | 任意可用解析度                                               |
|   JDOWNLOADER2_AUTO_START | 自動執行 JDownloader2 | yes         | yes \| no                                                    |
| JDOWNLOADER2_AUTO_RESTART | 永遠執行 JDwonloader2 | no          | yes \| no                                                    |

> *zh_TW - 繁體中文*
>
> *zh_CN - 簡體中文*
>
> *en_US - 英語*



| Container 內部資料夾路徑 | 說明                    |
| ------------------------ | ----------------------- |
| /dl                      | Jd2 下載的檔案存放目錄  |
| /usr/jd2/cfg             | Jd2 config files 資料夾 |





