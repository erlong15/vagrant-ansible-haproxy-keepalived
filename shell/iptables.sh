#!/bin/bash

systemctl disable firewalld
systemctl stop firewalld
systemctl mask firewalld

yum -y install iptables-services

iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

#ALLOW ON lo interface
iptables -A INPUT -i lo -j ACCEPT

#ALLOW PORTs
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
iptables -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -P OUTPUT ACCEPT

#INPUT POLICY SET TO DROP
iptables -P INPUT DROP

iptables-save > /etc/sysconfig/iptables
iptables-restore < /etc/sysconfig/iptables

systemctl enable iptables