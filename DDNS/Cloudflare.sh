#!/bin/bash

# 参数
ApiToken="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
Subdomain="subdomain"
Domain="example.com"
DnsType="AAAA"
TtlTime="60"
Proxy="false"
CloudflareApi="https://api.cloudflare.com/client/v4"
# 读取本地IP
LocalIp=$(ip -6 addr | grep :: | awk -F '[ \t]+|/' '{print $3}' | grep -v ^::1 | grep -v ^fe80)
# 读取Zone ID
GetZoneApi="${CloudflareApi}/zones"
GetZone=$(curl -s -X GET "$GetZoneApi" -H "Authorization: Bearer $ApiToken" -H "Content-Type:application/json")
# 读取反馈状态
GetZoneSuccess=$(echo "$GetZone" | jq -r ".success")
if [[ $GetZoneSuccess = "true" ]]; then
    echo "GetZoneOK"
else
    echo "GetZoneNG"
    exit 0
fi
ZoneId=$(echo "$GetZone" | jq -r ".result[0].id")
# 读取Record ID & IP
GetRecordApi="${CloudflareApi}/zones/${ZoneId}/dns_records?type=${DnsType}&name=${Subdomain}.${Domain}"
GetRecord=$(curl -s -X GET "$GetRecordApi" -H "Authorization: Bearer $ApiToken" -H "Content-Type:application/json")
# 读取反馈状态
GetRecordSuccess=$(echo "$GetRecord" | jq -r ".success")
if [[ $GetRecordSuccess = "true" ]]; then
    echo "GetRecordOK"
else
    echo "GetRecordNG"
    exit 0
fi
# 提取在线记录的ID与IP
RecordId=$(echo "$GetRecord" | jq -r ".result[0].id")
RecordIp=$(echo "$GetRecord" | jq -r ".result[0].content")
# 判断IP是否相同
if [[ $RecordIp = $LocalIp ]]; then
    echo "IpNoChange"
    exit 0
fi
# 如果ID不存在建立新记录
if [[ $RecordId = "null" ]]; then
    CreateRecordApi="$CloudflareApi/zones/${ZoneId}/dns_records"
    CreateRecord=$(curl -s -X POST "$CreateRecordApi" -H "Authorization: Bearer $ApiToken" -H "Content-Type:application/json" --data "{\"type\":\"$DnsType\",\"name\":\"$Subdomain.$Domain\",\"content\":\"$LocalIp\",\"ttl\":$TtlTime,\"proxied\":$Proxy}")
    # 读取反馈状态
    CreateRecordSuccess=$(echo "$CreateRecord" | jq -r ".success")
    if [[ $CreateRecordSuccess = "true" ]]; then
        echo "CreateRecordOK"
    else
        echo "CreateRecordNG"
    fi
# 更新记录
else
    UpdateRecordApi="$CloudflareApi/zones/${ZoneId}/dns_records/${RecordId}"
    UpdateRecord=$(curl -s -X PUT "$UpdateRecordApi" -H "Authorization: Bearer $ApiToken" -H "Content-Type:application/json" --data "{\"type\":\"$DnsType\",\"name\":\"$Subdomain.$Domain\",\"content\":\"$LocalIp\",\"ttl\":$TtlTime,\"proxied\":$Proxy}")
    # 读取反馈状态
    UpdateRecordSuccess=$(echo "$UpdateRecord" | jq -r ".success")
    if [[ $UpdateRecordSuccess = "true" ]]; then
        echo "UpdateRecordOK"
    else
        echo "UpdateRecordNG"
    fi
fi
