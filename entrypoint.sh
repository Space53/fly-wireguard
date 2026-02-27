#!/bin/bash

mkdir -p /etc/wireguard

# Генерируем ключи, если их нет
if [ ! -f /etc/wireguard/privatekey ]; then
    wg genkey | tee /etc/wireguard/privatekey | wg pubkey > /etc/wireguard/publickey
fi

# Создаем конфиг WireGuard
cat > /etc/wireguard/wg0.conf << INNER
[Interface]
PrivateKey = $(cat /etc/wireguard/privatekey)
Address = 10.0.0.1/24
ListenPort = 51820
SaveConfig = false

# Включаем NAT для клиентов
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
INNER

# Запускаем WireGuard
wg-quick up wg0

# Держим контейнер запущенным
tail -f /dev/null
