# Synology Docker 折腾记录<br>
## 原始方案<br>
在群晖里面使用VMM搭建了OpenWrt,作为总网关负责全家的网络,外面连接AP<br>
里面搭载了OpenClash,KMS,Socat,DDNS的服务来满足日常的需求<br>
群晖docker里面还搭载了HomeAssistant<br>
## 思路<br>
VMM占资源太高了,也没用到什么特别的功能,使用docker全部可以实现,降低资源占用<br>
## 总结<br>
拨号由群晖完成<br>
需要的服务由Docker实现<br>
docker安装clash实现透明代理<br>
功能基本实现<br>
## Iptable<br>
越研究发现坑越多<br>
群晖的iptables被阉割了,缺失相关模块<br>
https://github.com/sjtuross/syno-iptables<br>
下载相关模块,修改文件,把insmod加入到docker服务启动前<br>
确保docker服务启动前相关模块加载完成<br>
再写个开机的sh修改iptables就ok了<br>
1. 开启IPV4的转发<br>
2. 添加icmp的响应<br>
3. 添加路由规则<br>
4. 所有流量转发CLASH链<br>
5. 跳过保留地址<br>
6. 本地流量转发到tproxy-port端口并设置mark<br>
7. 转发DNS请求到clash的dns端口<br>
8. 至此tcp,udp,dns都由clash处理了<br>
## Clash<br>
官方的镜像直接拉取<br>
映射相关的文件与文件夹到真实目录<br>
1. config.yaml:/root/.config/clash/config.yaml<br>
2. Country.mmdb:/root/.config/clash/Country.mmdb<br>
3. rule_providers:/root/.config/clash/rule_providers<br>
4. ui:/root/.config/clash/ui<br><br>
## DDNS<br>
我的域名托管的是Cloudflare,解决方案还是很多的,有Docker也有sh<br>
家里只有公网IPV6没有IPV4<br>
照着别人的sh自己写一个吧,适合的才是最好的<br>
只要域名,子域名,Api Token三个参数,脚本自动获取Zone ID与Record ID<br>
没记录自动建立,记录不同自动修改<br>
定时调用就完事了<br>
sh脚本实在太难写了,各种括号,每个人的写法也不同<br>
一边写一边echo<br>
