#!/bin/bash
    set -e
    if [ -f /etc/debian_version ]; then
      apt-get update -y
      apt-get install -y python3
      if [ "${var.instance_kind}" = "web" ]; then apt-get install -y apache2; systemctl enable --now apache2; fi
    else
      yum -y install python3
      if [ "${var.instance_kind}" = "web" ]; then amazon-linux-extras install -y nginx1 || yum -y install nginx; systemctl enable --now nginx; fi
    fi