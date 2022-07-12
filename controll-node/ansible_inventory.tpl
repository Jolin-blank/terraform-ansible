[salt]
%{ for addr in salt_ip_addrs ~}
ansible_host=${addr}  ansible_user=${user}
%{ endfor ~}
[yum]
%{ for addr in yum_ip_addrs ~}
ansible_host=${addr}  ansible_user=${user}
%{ endfor ~}
