#!/bin/bash

echo "[+] Starting server hardening..."

# 1. Start with disabling unnecessary services to reduce attack surface
echo "[+] Disabling unnecessary services..."
systemctl disable --now pollinate.service
systemctl disable --now ubuntu-advantage.service
systemctl disable --now open-vm-tools.service
systemctl disable --now lxd-agent.service
systemctl disable --now snapd.service snapd.apparmor.service snap.lxd.activate.service
systemctl disable --now systemd-networkd-wait-online.service

# 2. Next step is installing Security Auditing Tools
echo "[+] Installing Security Tools (Rkhunter, Chkrootkit, Lynis)..."
apt update
apt install -y rkhunter chkrootkit lynis fail2ban ufw

# 3. Next step is to configure the Firewall (ufw) to default deny. This denies all incoming trafic by default, you'll need exception rules to allow traffic
echo "[+] Configuring Firewall rules..."
ufw default deny incoming
ufw default allow outgoing

# Allow SSH from our VPN ips - so we can only access the server when we're connected to our VPN.
# Replace with your own VPN ip-adresses.
ufw allow from 10.0.0.0/24 to any port 22 proto tcp
ufw allow from 10.0.0.6 to any port 22 proto tcp

# Enabling the firewall
echo "y" | ufw enable

# 4. testing our security auditing services
echo "[+] Running Rootkit Checks..."
rkhunter --check --sk
chkrootkit

echo "[+] Hardening Complete."
