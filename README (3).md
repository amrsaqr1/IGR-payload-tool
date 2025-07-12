# 🛡️ IGR - Android Payload Tool (by SaQr)

IGR (Invisible Generation & Remote) is a powerful Bash-based tool to generate, encrypt, and inject Android payloads into image files. Built for ethical hacking, penetration testing, and learning purposes.

IGR (اختصار لـ Invisible Generation & Remote) هي أداة متقدمة لتوليد بايلودات أندرويد مشفرة ودمجها داخل صور، مصممة لاختبار الحماية والتعليم فقط.

---

![IGR Tool Preview](igr-preview.png)

---

## 🚀 Features

- ✅ AES-256 Encryption + Base64 + ZIP
- ✅ Inject payload into image files (e.g., JPG → .apk)
- ✅ Add fake app name and icon
- ✅ Anti-VM code (detect emulators)
- ✅ QR code generator for delivery
- ✅ Metasploit Listener automation
- ✅ Works on Kali Linux and Termux

---

## ⚙️ Installation

### On Kali Linux / Debian:

```bash
sudo apt update && sudo apt install -y git
git clone https://github.com/amrsaqr1/IGR-payload-tool
cd IGR-payload-
chmod +x IGR.sh
./IGR.sh
```

### On Termux:

```bash
pkg update && pkg install -y git
git clone https://github.com/amrsaqr1/IGR-payload-tool
cd IGR-payload-
chmod +x IGR.sh
bash IGR.sh
```

---

## 🧪 Usage Steps

1. Generate encrypted payload.
2. Inject it into an image.
3. Share via QR code or directly.
4. Start listener and wait for connection.

---

## 💖 Support the Project

If this project helps you or saves you time, consider supporting the developer.  
Even a small donation helps keep the updates coming and the motivation strong 💪

[![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-%E2%98%95-orange?style=flat-square&logo=buy-me-a-coffee)](https://ko-fi.com/saqr306)

📲 Etisalat Cash (Egypt): `01110719296`

---

## ⚠️ Disclaimer

> This tool is for **educational and authorized penetration testing only**.  
> Any misuse of this tool is the sole responsibility of the user.  
> The developer **(SaQr)** is not responsible for any illegal usage or damage caused.

---

## 📜 License

MIT License — Free to use with ethical intent.
