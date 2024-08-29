#!/bin/sh

# Цветовая схема
green="\033[1;32m" # Green
red="\033[31m"     # Red
nc="\033[0m"       # No Color

# Удаляем из /etc/apt/sources.list.d/altsp.list "cdrom"
apt-repo rm all cdrom

# Раскомментируем репозитории Alt
sed -i '/http/s/^#//' /etc/apt/sources.list.d/altsp.list

echo "Проверка соединения..."
ping -c 2 yandex.ru &> /dev/null

if [ $? -eq 0 ]; then
  # Обновляем списки пакетов
  if ! apt-get update; then
    echo ""
    echo -e "${red} Не удалось обновить список пакетов !${nc}"
    echo ""
    exit 1
  fi

  # Удаляем Firefox и Thunderbird
  apt-get remove firefox-esr thunderbird -y

  # Устанавливаем пакеты с носителя , если существует версия свежее, скачает с репозитория.
  apt-get dist-upgrade -y -o dir::cache=$(dirname "$0")/install_script_10/update/

  # Обновляем ядро
  update-kernel -y

  # Чистим кэш и перезагружаемся
  apt-get clean
  reboot
else
  echo ""
  echo -e "${red} Интернет соединение не доступно !${nc}"
  echo ""
  exit 1
fi
