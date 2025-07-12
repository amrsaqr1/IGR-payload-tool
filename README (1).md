# 🛡️ IGR - أداة توليد بايلودات أندرويد | Android Payload Tool (by SaQr)
![IGR Tool Preview](igr-preview.png)


IGR (اختصار لـ Invisible Generation & Remote) هي أداة قوية بلغة Bash لتوليد، تشفير، وحقن بايلودات أندرويد داخل صور، مع خواص متقدمة لحماية وتحليل الأنظمة.

IGR is a powerful Bash-based framework to generate, encrypt, and inject Android payloads inside images. Designed by **SaQr** for ethical hacking and cybersecurity learning.

---

## 📌 الميزات | Features

- 🔐 تشفير متقدم (AES-256 + Base64 + ZIP)
- 🖼️ دمج البايلود داخل صورة بامتداد APK
- 🎭 تغيير اسم التطبيق والأيقونة
- 🧠 كود كشف المحاكيات (Anti-VM)
- 🎯 توليد QR Code لمشاركة البايلود بسهولة
- ⚙️ تشغيل تلقائي لـ Metasploit Listener
- 💻 يدعم Kali Linux و Termux بشكل كامل

---

## 🧑‍💻 المطوّر | Developer

- الاسم: **SaQr**
- GitHub: [github.com/yourusername](https://github.com/yourusername)
- للتواصل أو الدعم: (أضف رابط تيليجرام/إيميل لو أحببت)

---

## 🧪 خطوات التشغيل | How to Use

### 🐧 على Kali Linux / Debian:

```bash
sudo apt update && sudo apt install -y git
git clone https://github.com/yourusername/igr-payload-tool
cd igr-payload-tool
chmod +x IGR.sh
./IGR.sh
```

### 📱 على Termux:

```bash
pkg update && pkg install -y git
git clone https://github.com/yourusername/igr-payload-tool
cd igr-payload-tool
chmod +x IGR.sh
bash IGR.sh
```

---

## 🎯 أمثلة على الاستخدام | Example Workflow

1. توليد البايلود باستخدام الخيار 1.
2. دمج البايلود في صورة عبر الخيار 2.
3. مشاركة الملف النهائي (صورة مموهة).
4. تشغيل Listener عبر Metasploit وانتظار الاتصال.

---


## 💖 Support the Project

If this project helps you or saves you time, consider supporting the developer.  
Even a small donation helps keep the updates coming and the motivation strong 💪

[![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-%E2%98%95-orange?style=flat-square&logo=buy-me-a-coffee)](https://ko-fi.com/saqr306)

📲 Etisalat Cash (Egypt): `01110719296`
