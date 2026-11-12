#!/bin/bash
curl -fsSL https://get.docker.com | sh
id ssm-user &>/dev/null || useradd -m ssm-user
usermod -aG docker ssm-user
docker run -d -p 80:80 nginx
docker run -d --network host cloudflare/cloudflared:latest \
  tunnel --no-autoupdate run --token ${tunnel_token}

# user_data hanya jalan sekali masa first boot, dan module EC2 tak replace instance bila user_data berubah by default. Jadi terraform apply biasa takkan betulkan. Buat salah satu:

# bash
# terraform apply -replace='module.my_server_private.aws_instance.this[0]'

# atau tambah user_data_replace_on_change = true dalam module my_server_private. Kalau alamat resource tak sama, check dengan terraform state list | grep private.