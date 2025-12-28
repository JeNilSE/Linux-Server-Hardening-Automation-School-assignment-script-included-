# Linux server hardening & security audit

## 🌄 Project Overview
This project contains the security configuration and hardening scripts used for a made-up enterprise infrastructure ("IT-Box" - the name of our group we used for our school project). My role was to secure the DNS, mail, and VPN servers running on Ubuntu in Microsoft Azure.

**Key Responsibilities:**
* **Attack Surface Reduction:** Disabled unused services and daemons.
* **Intrusion Prevention:** Configured **Fail2Ban** to block brute-force attacks on SSH and Mail services.
* **Firewall Management:** Implemented strict **UFW** rules, allowing SSH only from the internal VPN network.
* **Auditing:** Performed vulnerability scans using **Lynis**, **rkhunter**, and **chkrootkit**.

## 💪 Hardening Measures

### 1. Service Hardening
To minimize potential vulnerabilities, the following non-essential services were disabled:
* `snapd` & `lxd` (Container services not in use)
* `open-vm-tools` (Not needed for this specific Azure setup)
* `pollinate` & `ubuntu-advantage`

### 2. DNS Security (BIND9)
The DNS server was hardened to prevent DNS Amplification attacks and unauthorized queries:
* **Recursion:** Restricted to internal VNet clients only.
* **Listening:** Bind only to internal private IP (10.0.0.8).
* **Transfer:** Zone transfers disabled (`allow-transfer { "none"; };`).

### 3. Intrusion Detection & Prevention
**Fail2Ban** was deployed on all nodes with specific jails for:
* **SSHD:** Bans IPs after 5 failed attempts (Bantime: 120s).
* **Postfix/Dovecot:** Monitors mail authentication logs.
* **IgnoreIP:** Whitelisted internal subnet (10.0.0.0/24) to prevent locking out administrators.

### 4. Continuous Auditing
Automated checks were implemented using industry-standard tools:
* **Lynis:** For in-depth system security auditing.
* **Chkrootkit & Rkhunter:** To scan for rootkits and suspicious file modifications.

## 📜 Repository Contents
* `harden.sh` - Bash script for automating service disablement and tool installation.
* `jail.local` - Configuration file for Fail2Ban.

---
*Security Configuration by [Me](https://github.com/JeNilSE)*
