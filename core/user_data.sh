#!/bin/bash
set -euxo pipefail

# Amazon Linux 2
yum -y install squid

if ! grep -q '^acl vpc ' /etc/squid/squid.conf; then
  sed -i '1i acl vpc src ${var.vpc_cidr}' /etc/squid/squid.conf
fi
if ! grep -q '^http_access allow vpc' /etc/squid/squid.conf; then
  sed -i '/^http_access deny all/i http_access allow vpc' /etc/squid/squid.conf
fi

systemctl enable --now squid