# 开启IP转发
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o ppp0 -j MASQUERADE
# 建立新链
iptables -t nat -N CLASH_TCP
iptables -t nat -F CLASH_TCP
# 转发本地流量到CLASH_TCP
iptables -t nat -A PREROUTING -p tcp -s 192.168.0.0/16 -j CLASH_TCP
# 过滤保留地址
iptables -t nat -A CLASH_TCP -d 0.0.0.0/8 -j RETURN
iptables -t nat -A CLASH_TCP -d 10.0.0.0/8 -j RETURN
iptables -t nat -A CLASH_TCP -d 100.64.0.0/10 -j RETURN
iptables -t nat -A CLASH_TCP -d 127.0.0.0/8 -j RETURN
iptables -t nat -A CLASH_TCP -d 169.254.0.0/16 -j RETURN
iptables -t nat -A CLASH_TCP -d 172.16.0.0/12 -j RETURN
iptables -t nat -A CLASH_TCP -d 192.0.0.0/24 -j RETURN
iptables -t nat -A CLASH_TCP -d 192.0.2.0/24 -j RETURN
iptables -t nat -A CLASH_TCP -d 192.88.99.0/24 -j RETURN
iptables -t nat -A CLASH_TCP -d 192.168.0.0/16 -j RETURN
iptables -t nat -A CLASH_TCP -d 198.51.100.0/24 -j RETURN
iptables -t nat -A CLASH_TCP -d 203.0.113.0/24 -j RETURN
iptables -t nat -A CLASH_TCP -d 224.0.0.0/4 -j RETURN
iptables -t nat -A CLASH_TCP -d 240.0.0.0/4 -j RETURN
iptables -t nat -A CLASH_TCP -d 255.255.255.255/32 -j RETURN
# 开启TCP转发
iptables -t nat -A CLASH_TCP -p tcp -s 192.168.0.0/16 -j REDIRECT --to-ports 7892
# 开启DNS转发
iptables -t nat -A PREROUTING -p udp -d 192.168.0.0/16 --dport 53 -j REDIRECT --to-ports 1053

