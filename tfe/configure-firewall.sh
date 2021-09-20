#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/ 

# https://serverfault.com/questions/214996/iptables-allow-ssh-access-only-nothing-else-in-or-out
# Flushing all rules
iptables -F
iptables -X

# Setting default filter policy
iptables -P INPUT DROP
iptables -P OUTPUT DROP
# iptables -P FORWARD DROP

# Allow unlimited traffic on loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# allow SSH from the Host VM to this guest VM
iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT

# allow HTTP to the Replicated UI
iptables -A INPUT -p tcp -m tcp --dport 8800 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 8800 -m state --state ESTABLISHED -j ACCEPT

# allow HTTPS to TFE
iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 443 -m state --state ESTABLISHED -j ACCEPT

# allow Docker comminucation
# iptables -A FORWARD -i eth0 -o docker0 --state RELATED,ESTABLISHED -j ACCEPT
