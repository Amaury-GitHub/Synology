#!/bin/bash

# 等待网卡就绪
sleep 1m
# 开启IP转发
sysctl -w net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -o ppp0 -j MASQUERADE
# 修复 ICMP
sysctl -w net.ipv4.conf.all.route_localnet=1
iptables -t nat -A PREROUTING -p icmp -d 198.18.0.0/16 -j DNAT --to-destination 127.0.0.1
# 转发默认 DNS端口 到 CLASH-DNS 端口
iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to 1053
# 添加路由策略
ip rule add fwmark 1 lookup 100
ip route add local default dev lo table 100
# 添加 CLASH 链
iptables -t mangle -N CLASH
# 跳过保留地址
iptables -t mangle -A CLASH -d 0.0.0.0/8 -j RETURN
iptables -t mangle -A CLASH -d 10.0.0.0/8 -j RETURN
iptables -t mangle -A CLASH -d 100.64.0.0/10 -j RETURN
iptables -t mangle -A CLASH -d 127.0.0.0/8 -j RETURN
iptables -t mangle -A CLASH -d 169.254.0.0/16 -j RETURN
iptables -t mangle -A CLASH -d 172.16.0.0/12 -j RETURN
iptables -t mangle -A CLASH -d 192.168.0.0/16 -j RETURN
iptables -t mangle -A CLASH -d 224.0.0.0/4 -j RETURN
iptables -t mangle -A CLASH -d 240.0.0.0/4 -j RETURN
# 跳过内网固定 IP 段
iptables -t mangle -A CLASH -s 192.168.1.0/26 -j RETURN
# 跳过 NTP 端口
iptables -t mangle -A CLASH -p udp --dport 123 -j RETURN
# 其他流量转发到 TPROXY 端口，并设置 mark
iptables -t mangle -A CLASH -j TPROXY -p tcp -s 192.168.1.0/24 --on-port 7893 --tproxy-mark 1
iptables -t mangle -A CLASH -j TPROXY -p udp -s 192.168.1.0/24 --on-port 7893 --tproxy-mark 1
# 所有流量通过 CLASH 链进行处理
iptables -t mangle -A PREROUTING -j CLASH
