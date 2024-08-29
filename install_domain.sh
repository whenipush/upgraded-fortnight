#!/bin/bash

############################### АДРЕС ПЕРВОЙ СЕТЕВОЙ ПАПКИ #####################################
share_addr="srv-share.corp.legionsecurity.ru" # Адрес сервера с сетевым каталогом
share_dir="share"                             # Имя каталога
################################################################################################

############################### АДРЕС ВТОРОЙ СЕТЕВОЙ ПАПКИ #####################################
share_addr2="srv-share.corp.legionsecurity.ru" # Адрес сервера с сетевым каталогом 2
share_dir2="share/it"                          # Имя каталога
################################################################################################

########################### МЕНЯЕМ ПЕРЕМЕННЫЕ ДЛЯ ДОМЕНА #######################################
# Адрес контроллера домена
DC_ADDR="192.168.20.99"
# FQDN
DOMAIN_NAME="corp.legionsecurity.ru"
# Рабочая группа
WORKGROUP="LEGION"
# Логин администратора домена
DOMAIN_LOGIN="user"
# Пароль администратора домена
DOMAIN_PASS="pass"

###############################################################################################

###################################### Основной блок ##########################################
function main() {
  user      # Определяет имя пользователя в системе Alt Linux
  host_name # Задает ИМЯ хоста вида "arm-<номер dst>" интерактивно
  #timezone  # Установит часовой пояс , РЕДАКТИРОВАТЬ под свой регион если включен
  extension # Установка плагинов в Yandex браузер
  windows   # Cтиль Windows
  install   # Установки программ
  share     # Запустит блок "share"
  #share2         # Запустит блок "share2"
  http_link      # Создает html страничку с ссылками
  print          # Блок для принтеров
  video          # Установка драйвера для Nvidia
  integalert fix # Целостность системы
  reboot         # Перезагрузка обязательна
}
###############################################################################################

###################################### Блок timezone ##########################################
function timezone() {
  # Установит часовой пояс в системе ( редактировать под свой регион )
  timedatectl set-timezone Europe/Samara
}
###############################################################################################

###################################### Блок install ###########################################
function install() {
  # Удаляем старые ядра
  remove-old-kernels -y

  # Установка программ
  apt-get update
  apt-get install -y -o dir::cache=$dir/install_script_10/update2 pam-limits-desktop gnome-disk-utility yandex-browser ocrfeeder \
    sane simple-scan sane-airscan unrar fonts-ttf-ms fonts-ttf-google-crosextra-carlito fonts-ttf-google-noto-sans

  # Устанавливаем rpm пакеты Ассистент, МойОфис, VipNet Client, TrueConf, NAPS2
  apt-get install -y -o dir::cache=$dir/install_script_10/update2 $dir/install_script_10/*.rpm

  # Среда (ГКС)
  mkdir -p /opt/sreda
  tar -xf $dir/install_script_10/sreda_24.2.tar.xz -C /opt/sreda

  # КриптоПро
  # Пакеты зависят друг от друга, поэтому должны устанавливаться по порядку с учётом этих зависимостей
  # Пакеты для предварительной установки
  # Пакет совместимости с ОС AltLinux
  # из ГУИ не устанавливается

  ####Описание пакетов
  # Базовый пакет КриптоПро CSP
  # Модуль поддержки основных приложений, считывателей и ДСЧ
  # Провайдер класса КС1
  # CAPILite, программы и библиотеки для высокоуровневой работы с криптографией (сертификатами, CMS...)
  # Пакет для работы Curl с поддержкой российских алгоритмов
  # Корневые сертификаты доверенных ЦС сертификат Минцифры присутствует
  # Графический интерфейс для диалоговых операций
  # Графическое приложение для доступа к основным функциям и настройкам КриптоПро CSP
  # Модули поддержки PCSC-считывателей, смарт-карт
  # Модуль поддержки PKCS#11
  # Модуль поддержки смарт-карт и токенов Рутокен
  # Модуль поддержки смарт-карт и токенов JaCarta
  # Модуль поддержки ключей PKCS#11
  # Пакет с инструментарием разработчика для создания клиентских и серверных приложений для работы с ЭП
  # Пакет для работы КриптоПро ЭЦП Browser plug-in
  # IFCP plugin для входа в Госуслуги (ЕСИА)
  # Поддержка Rutoken S

  apt-get install -y $dir/install_script_10/CryptoProR3/cprocsp-compat-altlinux-64-1.0.0-1.noarch.rpm \
    $dir/install_script_10/CryptoProR3/lsb-cprocsp-base-5.0.13000-7.noarch.rpm \
    $dir/install_script_10/CryptoProR3/lsb-cprocsp-rdr-64-5.0.13000-7.x86_64.rpm \
    $dir/install_script_10/CryptoProR3/lsb-cprocsp-kc1-64-5.0.13000-7.x86_64.rpm \
    $dir/install_script_10/CryptoProR3/lsb-cprocsp-capilite-64-5.0.13000-7.x86_64.rpm \
    $dir/install_script_10/CryptoProR3/cprocsp-curl-64-5.0.13000-7.x86_64.rpm \
    $dir/install_script_10/CryptoProR3/lsb-cprocsp-ca-certs-5.0.13000-7.noarch.rpm \
    $dir/install_script_10/CryptoProR3/cprocsp-rdr-gui-gtk-64-5.0.13000-7.x86_64.rpm \
    $dir/install_script_10/CryptoProR3/cprocsp-cptools-gtk-64-5.0.13000-7.x86_64.rpm \
    $dir/install_script_10/CryptoProR3/cprocsp-rdr-pcsc-64-5.0.13000-7.x86_64.rpm \
    $dir/install_script_10/CryptoProR3/lsb-cprocsp-pkcs11-64-5.0.13000-7.x86_64.rpm \
    $dir/install_script_10/CryptoProR3/cprocsp-rdr-rutoken-64-5.0.13000-7.x86_64.rpm \
    $dir/install_script_10/CryptoProR3/cprocsp-rdr-jacarta-64-5.0.13000-7.x86_64.rpm \
    $dir/install_script_10/CryptoProR3/cprocsp-rdr-cryptoki-64-5.0.13000-7.x86_64.rpm \
    $dir/install_script_10/CryptoProR3/cprocsp-pki-cades-64-2.0.15000-1.amd64.rpm \
    $dir/install_script_10/CryptoProR3/cprocsp-pki-plugin-64-2.0.15000-1.amd64.rpm \
    $dir/install_script_10/CryptoProR3/IFCPlugin-x86_64.rpm \
    $dir/install_script_10/CryptoProR3/ifd-rutokens_1.0.4_1.x86_64.rpm

  cp $dir/install_script_10/CryptoProR3/ifcx64.cfg /etc/ifc.cfg
  /opt/cprocsp/bin/amd64/csptestf -absorb -certs -autoprov
  cp /etc/opt/chrome/native-messaging-hosts/ru.rtlabs.ifcplugin.json /etc/chromium/native-messaging-hosts

  # Активация лицензии КриптоПро
  /opt/cprocsp/sbin/amd64/cpconfig -license -set 5050A-50000-0103X-WVG1Z-N52W3
  # Проверка активации лицензии
  /opt/cprocsp/sbin/amd64/cpconfig -license -view

  # Создаем каталог "Рабочий стол" в /etc/skel
  mkdir -p /etc/skel/Рабочий\ стол

  # Копируем "Руководства" в /etc/skel/Рабочий\ стол/
  cp -p -R $dir/install_script_10/Руководства/ /etc/skel/Рабочий\ стол/

  chmod -R 755 /etc/skel/Рабочий\ стол
  chown -R root:root /etc/skel/Рабочий\ стол

  # Устанавливаем язык в системе по умолчанию "RU"
  sed -i 's/Option "XkbLayout" "us,ru"/Option "XkbLayout" "ru,us"/' /etc/X11/xorg.conf.d/00-keyboard.conf

  # Добавляем отображение раскладки клавиатуры при входе в систему
  subst 's/^#\?indicators=.*/indicators=~clock;~spacer;~host;~spacer;~session;~layout;~a11y;~power/' /etc/lightdm/lightdm-gtk-greeter.conf || :

  # Добавляем пользователя в группу "lp"
  gpasswd -a $user lp

  # Включаем сервер печати
  systemctl enable cups --now &>/dev/null

  # Если домен в зоне .local выключаем avahi
  if [[ $DOMAIN_NAME == *".local" ]]; then
    chkconfig avahi-daemon off
  fi

  # Определяем имя сетевого интерфейса:
  NET_INT=""
  for iface in $(ip -o link show | awk -F': ' '{print $2}' | grep -v '^lo$'); do
    if ip -4 addr show "$iface" | grep -q "inet "; then
      NET_INT="$iface"
      break
    fi
  done

  if [ -z "$NET_INT" ]; then
    echo -e "${red}Не найдено подключенных сетевых интерфейсов.${nc}"
    exit 1
  fi

  if [ $NET_INT != 'enp1s0' ]; then
    mv /etc/net/ifaces/enp1s0 /etc/net/ifaces/$NET_INT
  fi

  # Выключаем dnsmasq
  systemctl disable dnsmasq &>/dev/null

  # Прописываем nameserver в /etc/net/ifaces/имя_интерфейса/resolv.conf
  echo -e "nameserver $DC_ADDR\n" >"/etc/net/ifaces/$NET_INT/resolv.conf"

  # Добавляем в группу lp пользователей домена
  if ! grep -q "^*;" "/etc/security/group.conf"; then
    echo "*; *; *; Al0000-2400; lp" >>"/etc/security/group.conf"
  fi

  if ! grep -q "pam_group.so" "/etc/pam.d/common-login"; then
    echo -e "auth\t\toptional\tpam_group.so" >>"/etc/pam.d/common-login"
  fi

  # Добавляем интерфейс в /etc/resolvconf.conf
  if ! grep -q "$NET_INT" "/etc/resolvconf.conf"; then
    sed -i -e "s/lo lo\[0-9\]\* lo\.\*/lo lo\[0-9\]\* lo\.\* $NET_INT/g" /etc/resolvconf.conf
  fi

  # Добавляем запись search_domains=имя_домена в /etc/resolvconf.conf
  if grep -q "search_domains=$DOMAIN_NAME" "/etc/resolvconf.conf"; then
    echo ""
  else
    echo -e "search_domains=$DOMAIN_NAME" >>"/etc/resolvconf.conf"
  fi

  echo -e "enter-username=true" >>"/etc/lightdm/lightdm-gtk-greeter.conf"

  # Прописываем в /etc/vipnet.conf рабочий каталог
  if ! grep -q "^config_dir=/.vipnet" "/etc/vipnet.conf"; then
    echo "config_dir=/.vipnet" >>"/etc/vipnet.conf"
  fi

  # Включение vipnet при входе пользователем через 10 секунд
  systemctl disable vipnetclient.service --force
  if ! grep -q "^sleep 10 && /usr/bin/vipnetclient start &" "/etc/profile"; then
    echo "sleep 10 && /usr/bin/vipnetclient start &" >>"/etc/profile"
  fi

  # Для нормальной работы с usb носителями , возможно группу "fuse" придется изменить на свою
  echo 'polkit.addRule(function(action, subject) {
    if (  ( action.id == "org.freedesktop.udisks2.filesystem-mount-other-seat" ||
    action.id == "org.freedesktop.udisks2.filesystem-unmount-others" ||
    action.id == "org.freedesktop.udisks2.encrypted-unlock-other-seat" ||
    action.id == "org.freedesktop.udisks2.eject-media-other-seat" ||
    action.id == "org.freedesktop.udisks2.power-off-drive-other-seat" ) &&
    subject.isInGroup("fuse"))
    {
    return polkit.Result.YES;
    }
});
' >/etc/polkit-1/rules.d/10-udisks2.rules

  # Временно добавляем в /etc/resolv.conf данные по домену , иначе до перезагрузки не зайдет в домен , потом перезапишется
  rm -rf /etc/resolv.conf

  cat <<EOF >/etc/resolv.conf
domain $DOMAIN_NAME
search $DOMAIN_NAME
nameserver $DC_ADDR
EOF

  # Получаем имя сетевого каталога
  share_name=$(echo "$share_addr" | cut -d '.' -f1)

  # Получаем ip адрес сетевого каталога , требуется для блока printer
  ip_addr_share=$(host $share_addr | awk '/has address/ { print $4 }')

  # добавляем в hosts
  if ! grep -q "$DOMAIN_NAME" /etc/hosts; then
    echo -e "$DC_ADDR\t$DOMAIN_NAME" | tee -a /etc/hosts
  fi

  if ! grep -q "$share_addr" /etc/hosts; then
    echo -e "$ip_addr_share\t$share_addr $share_name" | tee -a /etc/hosts
  fi

  # Ввод в домен
  echo ""
  echo -e ${green} "Попытка ввода в домен${nc}"
  echo ""
  system-auth write ad $DOMAIN_NAME $HNAME $WORKGROUP $DOMAIN_LOGIN $DOMAIN_PASS

  # Включаем cache_credentials
  sed -i 's/; cache_credentials = false/cache_credentials = true/' /etc/sssd/sssd.conf

  ####################################### post_install.sh #######################################
  # Дополнительный скрипт на рабочем столе
  ##############################################################################################
  cat <<EOF >/etc/skel/Рабочий\ стол/post_install.sh
#!/bin/bash
user=\$(who | awk '{print \$1}')

# Исправляет ярлык среды
sed -i "s|/home/$user|/home/${DOMAIN_NAME^^}/\$user|g" /home/${DOMAIN_NAME^^}/\$user/Рабочий\ стол/sredadesktop.desktop

# Запуск среды в фоне
nohup /opt/sreda/sreda > /dev/null 2>&1 &

# Тип подписи по умолчанию sig
/opt/cprocsp/sbin/amd64/cpconfig -ini '\local\cptools\create_sign' -add string signature_extension sig

# Отсоединенная подпись по умолчанию
/opt/cprocsp/sbin/amd64/cpconfig -ini '\local\cptools\create_sign' -add long is_detached 1

# Удаление скрипта после выполнения 
rm -rf ~/Рабочий\ стол/post_install.sh
EOF
  chmod +x /etc/skel/Рабочий\ стол/post_install.sh
  chown $user:$user /etc/skel/Рабочий\ стол/post_install.sh
  ##############################################################################################
}
##############################################################################################

###################################### Блок extension ########################################
function extension() {
  # Устанавливает плагины Госуслуг и КриптоПро на основе статьи "Установка в закрытом контуре" по ссылке:
  # https://yandex.ru/support2/browser-corporate/ru/deployment/closed-contour#extensionSettings-win
  # Плагины пользователям можно только отключить , удалить может суперпользователь:
  # Чтобы удалить плагины удаляем из под root файл /etc/opt/yandex/browser/policies/managed/extension_settings.json

  # Файл/плагин для КриптоПро с официального сайта https://addons.opera.com/en/extensions/details/cryptopro-extension-for-cades-browser-plug-in/
  # Плагин для Госуслуг качается с магазина расширений по идентификатору "pbefkdcndngodfeigfdgiodgnmbgcfha"

  # Создаем каталог для политик
  mkdir -p /etc/opt/yandex/browser/policies/managed

  # Копируем расширение КриптоПро
  cp $dir/install_script_10/ya_browser_extensions/cryptopro-extension-for-cades-browser-plug-in-1.2.13-1.crx /var/www/html/

  # Устанавливаем права
  chmod 644 /var/www/html/cryptopro-extension-for-cades-browser-plug-in-1.2.13-1.crx

  # Добавляем политики в файл
  cat <<'EOF' >/etc/opt/yandex/browser/policies/managed/extension_settings.json
{
  "ExtensionSettings": {
    "pbefkdcndngodfeigfdgiodgnmbgcfha": {
      "installation_mode": "normal_installed",
      "update_url": "https://clients2.google.com/service/update2/crx",
      "toolbar_pin": "force_pinned"
    },
    "epebfcehmdedogndhlcacafjaacknbcm": {
      "installation_mode": "normal_installed",
      "update_url": "http://localhost/update.xml",
      "toolbar_pin": "force_pinned"
    }
  }
}
EOF
  # Для КриптоПро указываем использовать локальный файл
  cat <<'EOF' >/var/www/html/update.xml
<gupdate xmlns="http://www.google.com/update2/response" protocol="2.0">
  <app appid="epebfcehmdedogndhlcacafjaacknbcm">
    <updatecheck codebase="http://localhost/cryptopro-extension-for-cades-browser-plug-in-1.2.13-1.crx" version="1.2.13"></updatecheck>
  </app>
</gupdate>
EOF

  systemctl restart httpd2
}
##############################################################################################

###################################### Блок hostname #########################################
function host_name() {
  while true; do
    echo ""
    echo -e "${green} Меняем hostname , для удобства формат 'arm-<nomer_dst>'${nc}"
    echo ""
    read -p "номер arm-:" HNAME
    if [[ $HNAME =~ ^(300|[1-2]?[0-9]?[0-9])$ ]]; then
      HNAME=arm-$HNAME
      echo "OK!"
      break
    else
      echo -e "${red}число от 1 до 300${nc}"
    fi
  done
  hostnamectl set-hostname $HNAME
}
##############################################################################################

###################################### Блок user #############################################
function user() {
  # Определяем имя пользователя в системе Alt Linux
  user=$(who | grep -v '^root' | awk '{print $1}')
}
###############################################################################################

###################################### Блок video #############################################
function video() {
  while true; do
    echo ""
    read -r -p $'\033[1;32m Устанавливаем драйвер для видеокарты Nvidia ?\033[31m (y/n)\033[0m : ' answer
    case "$answer" in
    [Yy]*)
      rpm -e $(rpm -qf $(modinfo -F filename nouveau))
      cp -r $dir/install_script_10/update2/archives/nvidia/* /var/cache/apt/archives/
      apt-get install -y -o dir::cache=$dir/install_script_10/update2 nvidia_glx_common
      yes | nvidia-install-driver
      make-initrd
      break
      ;;
    [Nn]*)
      break
      ;;
    *)
      echo -e "${red}Please answer y or n.${nc}"
      ;;
    esac
  done
}
###############################################################################################

###################################### Блок share & share2 ####################################
function share() {
  # Получаем ip адрес сетевого каталога
  share_addr_ip=$(host $share_addr | awk '/has address/ { print $4 }')

  # Определяем версию протокола smb
  versions=("3.1.1" "3.0" "2.1" "2.0" "1.0")
  mount_point="/mnt/test"

  echo ""
  echo -e "${green} Пробуем подключить ${nc}$(basename "${share_dir}")${green}${nc}"
  echo ""

  if [ ! -d "$mount_point" ]; then
    mkdir -p "$mount_point"
  fi

  while true; do
    echo "Проверка соединения..."
    echo ""
    ping -c 2 $share_addr &>/dev/null
    if [ ! $? -eq 0 ]; then
      echo ""
      echo -e "${red}  Адрес ${nc}$share_addr${red} для каталога ${nc}$(basename "${share_dir}")${red} не пингуется, проверить адрес или соединение!${nc}"
      echo ""
      break
    fi

    # Создаем файл /root/.creds с логином и паролем
    echo "username=$DOMAIN_LOGIN" >/root/.creds
    echo "password=$DOMAIN_PASS" >>/root/.creds
    chmod 600 /root/.creds

    # Попытка монтирования с указанным логином и паролем
    mounted=false
    for ver in "${versions[@]}"; do
      if timeout 5 mount -t cifs -o vers=$ver,cred=/root/.creds //"$share_addr_ip"/"$share_dir" "$mount_point" >/dev/null 2>&1; then
        echo ""
        echo -e "${green} Успешное подключение каталога ${nc}$(basename "${share_dir}") ${green}, версия SMB протокола - $ver ${nc}"
        echo ""
        mounted=true

        # Добавляем параметры монтирования в файл /etc/auto.tab
        echo "share1	-fstype=cifs,sec=krb5,multiuser,vers=$ver,cruid=\$USER,domain="${DOMAIN_NAME}" ://"${share_addr}"/"${share_dir}"" >/etc/auto.tab
        chmod 644 /etc/auto.tab

        # Делаем монтируемые каталоги видимыми всегда
        sed -i 's|/mnt/auto\t/etc/auto.tab\t-t\ 5|/mnt/auto\t/etc/auto.tab\t--timeout=60 --ghost|' /etc/auto.master

        # Стартуем и добавляем autofs в автозагрузку
        systemctl enable autofs --now &>/dev/null

        # Удаляем предыдущие ярлыки , если повторно используем скрипт
        rm -rf /home/$user/Рабочий\ стол/share*
        rm -rf /etc/skel/Рабочий\ стол/share*

        # Создаем ярлык на рабочем столе
        printf "%s\n" \
          "[Desktop Entry]" \
          "Type=Link" \
          "Version=1.0" \
          "Name=$(basename "${share_dir}")" \
          "Icon=folder-remote" \
          "URL=/mnt/auto/share1" >"/etc/skel/Рабочий стол/share1.desktop"

        # Добавляем в закладки файлового менеджера caja
        if [ ! -f "/home/$user/.config/gtk-3.0/bookmarks" ]; then
          mkdir -p "/home/$user/.config/gtk-3.0"
        fi
        echo "file:///mnt/auto/share1 $(basename "${share_dir}")" >/home/$user/.config/gtk-3.0/bookmarks

        mkdir -p "/etc/skel/.config/gtk-3.0"
        echo "file:///mnt/auto/share1 $(basename "${share_dir}")" >/etc/skel/.config/gtk-3.0/bookmarks
        break
      fi
    done

    # Проверка монтирования
    if [ "$mounted" = true ]; then
      break
    else
      echo ""
      echo -e "${red} Неудачная попытка монтирования ${nc}$(basename "${share_dir}")${red} , проверить логин или пароль ${nc}"
      echo ""
    fi

  done

  if mountpoint -q "$mount_point"; then
    umount "$mount_point"
  fi

  # Удаляем временный каталог
  if [ -d "$mount_point" ]; then
    rmdir "$mount_point"
  fi
}

function share2() {
  # Получаем ip адрес сетевого каталога
  share_addr2_ip=$(host $share_addr2 | awk '/has address/ { print $4 }')

  # Определяем версию протокола smb
  versions=("3.1.1" "3.0" "2.1" "2.0" "1.0")
  mount_point="/mnt/test"

  echo ""
  echo -e "${green} Пробуем подключить ${nc}$(basename "${share_dir2}")${green}${nc}"
  echo ""

  if [ ! -d "$mount_point" ]; then
    mkdir -p "$mount_point"
  fi

  while true; do
    echo "Проверка соединения..."
    echo ""
    ping -c 2 $share_addr2 &>/dev/null
    if [ ! $? -eq 0 ]; then
      echo ""
      echo -e "${red}  Адрес ${nc}$share_addr2${red} для каталога ${nc}$(basename "${share_dir2}")${red} не пингуется, проверить адрес или соединение!${nc}"
      echo ""
      break
    fi

    # Создаем файл /root/.creds2 с логином и паролем
    echo "username=$DOMAIN_LOGIN" >/root/.creds2
    echo "password=$DOMAIN_PASS" >>/root/.creds2
    chmod 600 /root/.creds2

    # Попытка монтирования с указанным логином и паролем
    mounted=false
    for ver2 in "${versions[@]}"; do
      if timeout 5 mount -t cifs -o vers=$ver2,cred=/root/.creds2 //"$share_addr2_ip"/"$share_dir2" "$mount_point" >/dev/null 2>&1; then
        echo ""
        echo -e "${green} Успешное подключение каталога ${nc}$(basename "${share_dir2}") ${green}, версия SMB протокола - $ver2 ${nc}"
        echo ""
        mounted=true

        # Добавляем параметры монтирования в файл /etc/auto.tab
        echo "share2	-fstype=cifs,sec=krb5,multiuser,vers=$ver2,cruid=\$USER,domain="${DOMAIN_NAME}" ://"${share_addr2}"/"${share_dir2}"" >>/etc/auto.tab
        chmod 644 /etc/auto.tab

        # Создаем ярлык на рабочем столе
        printf "%s\n" \
          "[Desktop Entry]" \
          "Type=Link" \
          "Version=1.0" \
          "Name=$(basename "${share_dir2}")" \
          "Icon=folder-remote" \
          "URL=/mnt/auto/share2" >"/etc/skel/Рабочий стол/share2.desktop"

        # Добавляем в закладки файлового менеджера caja
        if [ ! -f "/home/$user/.config/gtk-3.0/bookmarks" ]; then
          mkdir -p "/home/$user/.config/gtk-3.0"
        fi
        echo "file:///mnt/auto/share2 $(basename "${share_dir2}")" >>/home/$user/.config/gtk-3.0/bookmarks

        mkdir -p "/etc/skel/.config/gtk-3.0"
        echo "file:///mnt/auto/share2 $(basename "${share_dir2}")" >>/etc/skel/.config/gtk-3.0/bookmarks
        break
      fi
    done

    # Проверка монтирования
    if [ "$mounted" = true ]; then
      break
    else
      echo ""
      echo -e "${red} Неудачная попытка монтирования ${nc}$(basename "${share_dir2}")${red} ${nc}"
      echo ""
    fi

  done

  if mountpoint -q "$mount_point"; then
    umount "$mount_point"
  fi

  # Удаляем временный каталог
  if [ -d "$mount_point" ]; then
    rmdir "$mount_point"
  fi
}
###############################################################################################

################################# Блок print ##################################################
function print() {
  print_hp
}
function print_hp() {
  subnet=$(echo $DC_ADDR | awk -F '.' '{print $1"."$2"."$3}')
  while true; do
    echo ""
    read -r -p $'\033[1;32m Устанавливаем драйвер для HP (hp plugin} ?\033[31m (y/n)\033[0m : ' answer
    case "$answer" in
    [Yy]*)
      while true; do
        echo ""
        echo -e "${green} Далее если выбрать ${red}'n'${green} будет попытка подключения принтера по USB, если ${red}'y'${green} по Сети!${nc}"
        echo ""
        read -r -p $'\033[1;32m Принтер HP подключен по СЕТИ ?\033[31m (y/n)\033[0m : ' answer
        case "$answer" in
        [Yy]*)
          while true; do
            read -r -p "ip принтера $subnet." print_hp_ip
            if [[ $print_hp_ip =~ ^(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[1-9])$ ]]; then
              echo "OK!"
              break
            else
              echo -e "${red}число от 1 до 255${nc}"
            fi
          done
          yes | tr -d 'yes' | hp-plugin 2>/dev/null
          hp-setup -i -a -x "$subnet"."$print_hp_ip"
          break
          ;;
        [Nn]*)
          yes | tr -d 'yes' | hp-plugin 2>/dev/null
          yes | tr -d 'yes' | hp-setup -i -a
          break
          ;;
        *)
          echo -e "${red}Please answer y or n.${nc}"
          ;;
        esac
      done
      break
      ;;
    [Nn]*)
      break
      ;;
    *)
      echo -e "${red}Please answer y or n.${nc}"
      ;;
    esac
  done
}
###############################################################################################

###################################### Блок windows ###########################################
function windows() {
  apt-get install -y -o dir::cache=$dir/install_script_10/update2 theme-mate-windows icon-theme-windows-10

  # Сбрасываем настройки на дефолтные после установки утилиты
  dconf reset -f /

  mkdir -p /etc/dconf/profile
  mkdir -p /etc/dconf/db/local.d
  mkdir -p /etc/dconf/db/local.d/locks

  # Создаем профиль дял пользователей
  cat <<'EOF' >/etc/dconf/profile/user
user-db:user
system-db:local
EOF

  # Создаем файл настроек
  cat <<'EOF' >/etc/dconf/db/local.d/00_mate_panel_settings
[org/mate/caja/preferences]
default-folder-viewer='list-view'

[org/mate/desktop/interface]
font-name='Noto Sans 11'
icon-theme='Windows 10'

[org/mate/caja/desktop]
network-icon-visible=false

[org/mate/caja/window-state]
start-with-sidebar=true
start-with-status-bar=true
start-with-toolbar=true
maximized=true

[org/mate/desktop/peripherals/keyboard]
numlock-state='on'

[org/mate/settings-daemon/plugins/xrandr]
show-notification-icon=false

[org/mate/pluma]
display-line-numbers=true

[org/mate/mate-menu/plugins/applications]
last-active-tab=0

[org/mate/panel/general]
object-id-list=['menu-bar', 'show-desktop', 'window-list', 'notification-area', 'clock']
toplevel-id-list=['bottom']

[org/mate/panel/objects/clock]
applet-iid='ClockAppletFactory::ClockApplet'
locked=true
object-type='applet'
panel-right-stick=true
position=10
toplevel-id='bottom'

[org/mate/panel/objects/clock/prefs]
custom-format=''
format='24-hour'

[org/mate/panel/objects/menu-bar]
applet-iid='MateMenuAppletFactory::MateMenuApplet'
has-arrow=false
locked=true
object-type='applet'
position=0
toplevel-id='bottom'

[org/mate/panel/objects/notification-area]
applet-iid='NotificationAreaAppletFactory::NotificationArea'
locked=true
object-type='applet'
panel-right-stick=true
position=20
toplevel-id='bottom'

[org/mate/panel/objects/show-desktop]
applet-iid='WnckletFactory::ShowDesktopApplet'
locked=true
object-type='applet'
panel-right-stick=true
position=0
toplevel-id='bottom'

[org/mate/panel/objects/window-list]
applet-iid='WnckletFactory::WindowListApplet'
locked=true
object-type='applet'
position=92
toplevel-id='bottom'

[org/mate/panel/toplevels/bottom]
expand=true
monitor=0
orientation='bottom'
screen=0
size=30
EOF

  # Отключаем переключение языка при смене окон
  cat <<'EOF' >/etc/xdg/autostart/gsettings.desktop
[Desktop Entry]
Type=Application
Exec=gsettings set org.mate.peripherals-keyboard-xkb.general group-per-window 'false'
Hidden=false
X-MATE-Autostart-enabled=true
Name[ru_RU]=group-per-window 'false'
Name=group-per-window 'false'
Comment[ru_RU]=group-per-window 'false'
Comment=group-per-window 'false'
EOF

  # Создаем ярлыки на рабочем столе
  mkdir -p /etc/skel/Рабочий\ стол/

  cat <<'EOF' >/etc/skel/Рабочий\ стол/cptools.desktop
[Desktop Entry]
Type=Application
Name=CryptoPro Tools
Name[ru]=Инструменты КриптоПро
TryExec=/opt/cprocsp/bin/amd64/cptools
Exec=/opt/cprocsp/bin/amd64/cptools
Terminal=false
Icon=/opt/cprocsp/share/icons/cptools.png
Categories=Utility;Security;Settings;
Name[ru_RU]=КриптоПро
EOF

  cat <<'EOF' >/etc/skel/Рабочий\ стол/assistant.desktop
[Desktop Entry]
Type=Application
Name=Ассистент
Comment=Ассистент
Exec=/opt/assistant/scripts/assistant.sh
Terminal=false
Icon=/opt/assistant/share/icons/assistant.png
Categories=Network;
EOF

  cat <<EOF >/etc/skel/Рабочий\ стол/sredadesktop.desktop
[Desktop Entry]
Version=1.0
Name=Среда
Comment=Official desktop application for the Среда messaging service
Exec=/opt/sreda/sreda 4H65J7K68
Icon=/home/$user/.local/share/icons/sreda.png
Terminal=false
Type=Application
StartupWMClass=sreda
Categories=Network;InstantMessaging;Qt;
MimeType=x-scheme-handler/vkteams;x-scheme-handler/myteam-messenger;
X-Desktop-File-Install-Version=0.26
EOF

  cat <<'EOF' >/etc/skel/Рабочий\ стол/yandex-browser.desktop
[Desktop Entry]
Type=Application
Version=1.0
Name=Yandex Browser
GenericName=Web Browser
Comment=Access the Internet
Exec=/usr/bin/yandex-browser-stable %U
StartupNotify=true
Terminal=false
Icon=yandex-browser
Categories=Network;WebBrowser;
MimeType=application/pdf;application/rdf+xml;application/rss+xml;application/xhtml+xml;application/xhtml_xml;application/xml;image/gif;image/jpeg;image/png;image/webp;text/html;text/xml;x-scheme-handler/http;x-scheme-handler/https;
Actions=new-window;new-private-window;
Comment[ru]=Доступ в Интернет

[Desktop Action new-window]
Name=New Window
Name[ru]=Новое окно
Exec=/usr/bin/yandex-browser-stable

[Desktop Action new-private-window]
Name=New Incognito Window
Name[ru]=Новое окно в режиме инкогнито
Exec=/usr/bin/yandex-browser-stable --incognito
EOF

  cat <<'EOF' >/etc/skel/Рабочий\ стол/Сканирование.desktop
[Desktop Entry]
Type=Application
Version=1.0
Name=NAPS2
Comment=Not Another PDF Scanner
Exec=naps2
Icon=com.naps2.Naps2
Categories=Graphics;Office;Scanning;OCR;
MimeType=application/pdf;image/jpeg;image/png;image/tiff;image/bmp;
Name[ru_RU]=Сканирование
EOF

  cat <<'EOF' >/etc/skel/Рабочий\ стол/link.desktop
[Desktop Entry]
Type=Link
Version=1.0
Name=Ссылки
Icon=mate-panel-notification-area.png
URL=http://localhost
EOF

  chmod +x /etc/skel/Рабочий\ стол/*

  # Создаем mimeapps.list для приложений по умолчанию
  mkdir -p /etc/skel/.config/mimeapps.list/
  cat <<'EOF' >/etc/skel/.config/mimeapps.list/mimeapps.list
[Default Applications]
text/html=yandex-browser.desktop
application/vnd.openxmlformats-officedocument.wordprocessingml.document=libreoffice-writer.desktop
application/vnd.openxmlformats-officedocument.spreadsheetml.sheet=libreoffice-calc.desktop
application/pdf=atril.desktop

[Added Associations]
text/html=yandex-browser.desktop;
application/vnd.openxmlformats-officedocument.wordprocessingml.document=libreoffice-writer.desktop;
application/vnd.openxmlformats-officedocument.spreadsheetml.sheet=libreoffice-calc.desktop;
application/pdf=atril.desktop;
EOF
}
###############################################################################################

###################################### Блок http_link #########################################
function http_link() {
  cat <<'EOF' >/var/www/html/index.html
<!DOCTYPE html>
<html lang="ru">

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>Ссылки</title>
    <style type="text/css">
        #maket {
            display: flex;
        }

        .maket:not(:first-child) {
            border-top: 1px solid black;
        }

        .leftcol {
            text-align: center;
            width: 700px;
            background: #adabab;
            padding: 6px;
        }

        .rightcol {
            text-align: center;
            width: 700px;
            flex-grow: 1;
            background: #ccc;
            padding: 6px;
        }

        .container {
            width: 1400px;
            margin: auto;
        }
        .center-text {
            text-align: center;
            padding: 5px 5px;
            margin: 10x 10px;
            font-size: 30px;
        }
    </style>
</head>

<body>
    <div class="center-text">(X) - означает что веб-страница откроется без VipNet, сертификата и т.д.</div>
    <div class="container">
        <div class="maket" id="maket">
            <div class="leftcol"><a href="http://185.242.123.203">http://185.242.123.203</a></div>
            <div class="rightcol">АСУ КНД</div>
        </div>
        <div class="maket" id="maket">
            <div class="leftcol"><a href="https://esia.gosuslugi.ru">https://esia.gosuslugi.ru</a></div>
            <div class="rightcol">Госуслуги (X)</div>
        </div>
        <div class="maket" id="maket">
            <div class="leftcol"><a href="https://proverki.gov.ru">https://proverki.gov.ru</a></div>
            <div class="rightcol">Реестр проверок (X)</div>
        </div>
        <div class="maket" id="maket">
            <div class="leftcol"><a href="https://e.armgs.team/inbox">https://e.armgs.team/inbox</a></div>
            <div class="rightcol">ГКС (X)</div>
        </div>
        <div class="maket" id="maket">
            <div class="leftcol"><a href="https://prechecks.онлайнинспекция.рф/rostrud-progress">https://prechecks.онлайнинспекция.рф/rostrud-progress</a></div>
            <div class="rightcol">Онлайн Инспекция 1</div>
        </div>
        <div class="maket" id="maket">
            <div class="leftcol"><a href="https://онлайнинспекция.рф/panel">https://онлайнинспекция.рф/panel</a></div>
            <div class="rightcol">Онлайн Инспекция 2</div>
        </div>
        <div class="maket" id="maket">
            <div class="leftcol"><a href="http://10.5.9.53/Login.aspx?ReturnUrl=%2f">http://10.5.9.53/Login.aspx?ReturnUrl=%2f</a></div>
            <div class="rightcol">Директум</div>
        </div>
        <div class="maket" id="maket">
            <div class="leftcol"><a href="https://90.154.32.200/WebInterface/login.html#/parusjs">https://90.154.32.200/WebInterface/login.html#/parusjs</a></div>
            <div class="rightcol">ФТП сервер Роструда</div>
        </div>
        <div class="maket" id="maket">
            <div class="leftcol"><a href="https://rostrud.gov.ru/panel/">https://rostrud.gov.ru/panel/</a></div>
            <div class="rightcol">Приход поручений для Роструда (X)</div>
        </div>
        <div class="maket" id="maket">
            <div class="leftcol"><a href="https://edu.rostrud.ru/Account/Signin?returnUrl=/">https://edu.rostrud.ru/Account/Signin?returnUrl=/</a></div>
            <div class="rightcol">Тестирование госслужащих</div>
        </div>
        <div class="maket" id="maket">
            <div class="leftcol"><a href="http://192.168.1.222:8080/yza/login.html">http://192.168.1.222:8080/yza/login.html</a></div>
            <div class="rightcol">ВеГа</div>
        </div>
        <div class="maket" id="maket">
            <div class="leftcol"><a href="https://cloud.consultant.ru/cloud/cgi/online.cgi?req=home&rnd=3kcpA">https://cloud.consultant.ru/cloud/cgi/online.cgi?req=home&rnd=3kcpA</a></div>
            <div class="rightcol">Консультант Плюс (X)</div>
        </div>
        <div class="maket" id="maket">
            <div class="leftcol"><a href="https://trudvsem.ru/auth/manager/">https://trudvsem.ru/auth/manager/</a></div>
            <div class="rightcol">Работа в России (X)</div>
        </div>
        <div class="maket" id="maket">
            <div class="leftcol"><a href="https://buh2012.budget.gov.ru/buh2012/">https://buh2012.budget.gov.ru/buh2012/</a></div>
            <div class="rightcol">Облачный портал 1C</div>
        </div>
        <div class="maket" id="maket">
            <div class="leftcol"><a href="https://eb.cert.roskazna.ru/#/menu?view=jrt7eee0&backend=ARP&root=jrt7eee0">https://eb.cert.roskazna.ru/#/menu?view=jrt7eee0&backend=ARP&root=jrt7eee0</a></div>
            <div class="rightcol">Портал ФК</div>
        </div>
        <div class="maket" id="maket">
            <div class="leftcol"><a href="https://ssl.budgetplan.minfin.ru/bp/login?ReturnUrl=%2Fbp%2F#ProcurementProposals">https://ssl.budgetplan.minfin.ru/bp/login?ReturnUrl=%2Fbp%2F#ProcurementProposals</a></div>
            <div class="rightcol">Бюджетплан.минфин</div>
        </div>
        <div class="maket" id="maket">
            <div class="leftcol"><a href="https://mp.rosim.ru/">https://mp.rosim.ru/</a></div>
            <div class="rightcol">Портал Росимущества (X)</div>
        </div>
        <div class="maket" id="maket">
            <div class="leftcol"><a href="https://www.sberbank-ast.ru/">https://www.sberbank-ast.ru/</a></div>
            <div class="rightcol">Сбербанк-АСТ - электронная торговая площадка (X)</div>
        </div>
        <div class="maket" id="maket">
            <div class="leftcol"><a href="https://zakupki.gov.ru/epz/main/public/home.html">https://zakupki.gov.ru/epz/main/public/home.html</a></div>
            <div class="rightcol">Главная ЕИС в сфере закупок (X)</div>
        </div>
        <div class="maket" id="maket">
            <div class="leftcol"><a href="http://192.168.1.222:8080/ubr/login.html">http://192.168.1.222:8080/ubr/login.html</a></div>
            <div class="rightcol">АИС УБР</div>
        </div>
        <div class="maket" id="maket">
            <div class="leftcol"><a href="https://ufk18.sufd.budget.gov.ru">https://ufk18.sufd.budget.gov.ru</a></div>
            <div class="rightcol">СУФД</div>
        </div>
        <div class="maket" id="maket">
            <div class="leftcol"><a href="https://expertsout.rosmintrud.ru/">https://expertsout.rosmintrud.ru/</a></div>
            <div class="rightcol">Тестирование инспекторов, требуется Silverlight</div>
        </div>
        <div class="maket" id="maket">
            <div class="leftcol"><a href="http://10.5.9.75/SstuRf">http://10.5.9.75/SstuRf</a></div>
            <div class="rightcol">ССТУ, прием граждан</div>
        </div>
        <div class="maket" id="maket">
            <div class="leftcol"><a href="http://90.154.32.200/">http://90.154.32.200/</a></div>
            <div class="rightcol">Парус</div>
        </div>
        <div class="maket" id="maket">
            <div class="leftcol"><a href="https://gossluzhba.gov.ru/">https://gossluzhba.gov.ru/</a></div>
            <div class="rightcol">ЕИСУКС</div>
        </div>
    </div>
</body>

</html>
EOF

  systemctl restart httpd2

  dconf update

  rm -rf /home/$user/.config/dconf
  cp -p -R /etc/skel/Рабочий\ стол/* /home/$user/Рабочий\ стол/

  chmod -R 755 /home/$user/Рабочий\ стол/*
  chown -R $user:$user /home/$user/Рабочий\ стол/*

}
###############################################################################################

# Цветовая схема
green="\033[1;32m" # Green
red="\033[31m"     # Red
nc="\033[0m"       # No Color

# Проверка запущен ли скрипт от рута
[ "$(id -u)" -ne 0 ] && {
  echo -e "${red} Запускаем от суперпользователя (root) из консоли ( CTRL + ALT + F2 )! ${nc}"
  exit 1
}

# Определяем в переменную каталог в котором запускается сам скрипт
dir="$(dirname "$0")"

Logfile="$dir/logfile.txt"

# Создаст логфайл в корне (откуда запущен скрипт)
if [ ! -f "$dir/logfile.txt" ]; then
  touch "$dir/logfile.txt"
else
  >"$Logfile"
fi

exec 4>>"$Logfile"
BASH_XTRACEFD=4
set -x

main
set +x
