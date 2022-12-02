# set_hostname

Роль для изменения имени сервера. Имя берется из inventory-файла (переменная *inventory_hostname*).

## Пример playbook

```
- hosts: servers
  roles:
    - set_hostname
```
