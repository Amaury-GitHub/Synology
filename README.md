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
相关的资料太少了,为啥没什么人选择这样的架构呢,OpenWrt的倒很多
