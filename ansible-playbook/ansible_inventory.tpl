[all:children]
salt
yum
ntp
[salt]
%{ for addr in salt_ip_addrs ~}
${addr}  ansible_user=${user} ansible_password=${password}
%{ endfor ~}
[yum]
%{ for addr in yum_ip_addrs ~}
${addr}  ansible_user=${user} ansible_password=${password}
%{ endfor ~}
[ntp]
%{ for addr in ntp_ip_addrs ~}
${addr}  ansible_user=${user} ansible_password=${password}
%{ endfor ~}
