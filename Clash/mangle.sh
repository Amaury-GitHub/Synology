#!/bin/bash

sleep 2m
iptables -t mangle -C PREROUTING -j CLASH
if [[ $? = 0 ]]; then
    echo "Rule Exist"
    exit 0
else
    echo "Rule Not Exist"
    iptables -t mangle -A PREROUTING -j CLASH
fi
