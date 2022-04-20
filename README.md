# Synology All in One 记录<br>
# 原始方案<br>
在群晖里面使用VMM搭建了OpenWrt,作为总网关负责全家的网络,外面连接AP<br>
里面搭载了OpenClash,KMS,Socat,DDNS的服务来满足日常的需求<br>
群晖docker里面还搭载了HomeAssistant<br>
# 思路<br>
使用的还算稳定,群晖的性能还是太弱,CPU与内存的占用一直很高,VMM占资源感觉还是太多了<br>
于是开始寻找更好的方式<br>
反正都是All in One,VMM与Docker也没啥区别,反正都是主机挂了所有的都挂了<br>
想着直接由群晖拨号,其他的服务全部由Docker实现<br>
# 现方案<br>
群晖卸载VMM,所有的服务由Docker实现<br>
网络架构变得更简单,链路更短<br>
群晖的资源占用也变得更少了<br>
# 过程<br>
相关的资料太少了,为啥没什么人选择这样的架构呢,OpenWrt的倒很多<br>
## 拨号<br>
直接在群晖里面设置就ok了,可以正常获取到IPV6的地址<br>
但是办法给子网分配IPV6,内网反正也用不到<br>
拨号的网卡不设定IP,设定PPPOE<br>
另一个网卡设置IP与子网掩码,不设置网关<br>
dns指向内网的网卡IP<br>
## Clash<br>
官方的镜像直接拉取<br>
映射相关的文件与文件夹到真实目录<br>
1. config.yaml:/root/.config/clash/config.yaml<br>
2. Country.mmdb:/root/.config/clash/Country.mmdb<br>
3. rule_providers:/root/.config/clash/rule_providers<br>
4. ui:/root/.config/clash/ui<br>
<br>
写个sh定时更新Country.mmdb,基本上clash就不用管了,规则使用yaml配置定时更新<br>
ps:修改yaml的dns端口,53被占用了,不知道怎么停,做修改然后转发吧<br>
## Iptable<br>
写个开机的sh的就ok了<br>
1. 开启IPV4的转发<br>
2. 开启ppp0的NAT<br>
3. 劫持TCP流量给clash<br>
4. 劫持DNS请求给clash<br>
<br>
## DDNS<br>
我的域名托管的是Cloudflare,解决方案还是很多的,有Docker也有sh<br>
家里只有公网IPV6没有IPV4<br>
照着别人的sh自己写一个吧,适合的才是最好的<br>
只要域名,子域名,Api Token三个参数,脚本自动获取Zone ID与Record ID<br>
没记录自动建立,记录不同自动修改<br>
定时调用就完事了<br>
sh脚本实在太难写了,各种括号,每个人的写法也不同<br>
一边写一边echo<br>
