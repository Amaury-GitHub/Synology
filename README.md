# Synology All in One 记录
# 原始方案
在群晖里面使用VMM搭建了OpenWrt,作为总网关负责全家的网络,外面连接AP<br>
里面搭载了OpenClash,KMS,Socat,DDNS的服务来满足日常的需求<br>
群晖docker里面还搭载了HomeAssistant<br>
# 思路
使用的还算稳定,群晖的性能还是太弱,CPU与内存的占用一直很高,VMM占资源感觉还是太多了<br>
于是开始寻找更好的方式<br>
反正都是All in One,VMM与Docker也没啥区别,反正都是主机挂了所有的都挂了<br>
想着直接由群晖拨号,其他的服务全部由Docker实现<br>
# 现方案
群晖卸载VMM,所有的服务由Docker实现<br>
网络架构变得更简单,链路更短<br>
群晖的资源占用也变得更少了<br>
# 过程
相关的资料太少了,为啥没什么人选择这样的架构呢,OpenWrt的倒很多<br>
## 拨号
直接在群晖里面设置就ok了,可以正常获取到IPV6的地址<br>
但是办法给子网分配IPV6,内网反正也用不到<br>
## clash docker
官方的直接拉取
映射相关的文件与文件夹到真实目录
1. config.yaml:/root/.config/clash/config.yaml
2. Country.mmdb:/root/.config/clash/Country.mmdb
3. rule_providers:/root/.config/clash/rule_providers
4. ui:/root/.config/clash/ui
5. 修改yaml的dns端口,53被占用了,不知道怎么停,做修改然后转发吧
## Iptable
写个开机的sh的就ok了<br>
开启IPV4的转发<br>
开启ppp0的NAT<br>
劫持TCP流量给clash<br>
劫持DNS请求给clash<br>
问题:群晖本体没法通过clash上网,不知道咋写<br>
## DDNS
我的域名托管的是Cloudflare,解决方案还是很多的,有Docker也有sh<br>
家里只有公网IPV6没有IPV4<br>
照着别人的sh自己写一个吧,适合的才是最好的<br>
