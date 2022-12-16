# disable_selinux

Роль для выключения SELinux на CentOS. 

Состоит из одного *task* c условием `when: ansible_facts['distribution'] == 'CentOS'` для запуска только на CentOS.

## Пример playbook

```
- hosts: servers
  roles:
    - disable_selinux
```

