#!/bin/bash
# 等待网卡就绪
sleep 1m
# 开启IP转发
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o ppp0 -j MASQUERADE
# 开启TCP转发
iptables -t nat -N CLASH_TCP_RULE
iptables -t nat -F CLASH_TCP_RULE
iptables -t nat -A CLASH_TCP_RULE -d 10.0.0.0/8 -j RETURN
iptables -t nat -A CLASH_TCP_RULE -d 127.0.0.0/8 -j RETURN
iptables -t nat -A CLASH_TCP_RULE -d 169.254.0.0/16 -j RETURN
iptables -t nat -A CLASH_TCP_RULE -d 172.16.0.0/12 -j RETURN
iptables -t nat -A CLASH_TCP_RULE -d 192.168.0.0/16 -j RETURN
iptables -t nat -A CLASH_TCP_RULE -s 192.168.0.0/16 -p tcp -j REDIRECT --to-ports 7892
iptables -t nat -A OUTPUT -p tcp -d 198.18.0.0/16 -j REDIRECT --to-port 7892
iptables -t nat -A PREROUTING -p tcp -s 192.168.0.0/16 -j CLASH_TCP_RULE
# 开启DNS转发
iptables -t nat -N CLASH_DNS_RULE
iptables -t nat -F CLASH_DNS_RULE
iptables -t nat -A CLASH_DNS_RULE -p udp -s 192.168.0.0/16 --dport 53 -j REDIRECT --to-ports 1053
iptables -t nat -I OUTPUT -p udp --dport 53 -j CLASH_DNS_RULE
iptables -t nat -A PREROUTING -p udp -s 192.168.0.0/16 --dport 53 -j CLASH_DNS_RULE
