# Более мягкий лимит: 20 новых подключений в минуту на IP, всплеск 30
RATE_LIMIT="20/min"
RATE_BURST=30

# Пересоздаём цепочку
sudo iptables -N MTPROXY_LIMIT 2>/dev/null || true
sudo iptables -A MTPROXY_LIMIT -m hashlimit \
    --hashlimit-above "$RATE_LIMIT" \
    --hashlimit-burst "$RATE_BURST" \
    --hashlimit-mode srcip \
    --hashlimit-name mtproxy_rl \
    -j DROP
sudo iptables -A MTPROXY_LIMIT -j ACCEPT
sudo iptables -I INPUT -p tcp --dport <ТВОЙ_ПОРТ> -m conntrack --ctstate NEW -j MTPROXY_LIMIT

# Сохраняем
sudo netfilter-persistent save 2>/dev/null || sudo iptables-save > /etc/iptables/rules.v4


sudo iptables -N MTPROXY_LIMIT 2>/dev/null || true
sudo iptables -A MTPROXY_LIMIT -m hashlimit \
    --hashlimit-above "$RATE_LIMIT" \
    --hashlimit-burst "$RATE_BURST" \
    --hashlimit-mode srcip \
    --hashlimit-name mtproxy_rl \
    -j DROP
sudo iptables -A MTPROXY_LIMIT -j ACCEPT
sudo iptables -I INPUT -p tcp --dport $PROXY_PORT -m conntrack --ctstate NEW -j MTPROXY_LIMIT

# Сохраняем
sudo netfilter-persistent save 2>/dev/null || sudo iptables-save > /etc/iptables/rules.v4
