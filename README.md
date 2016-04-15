Role Name
=========

Creates Nexus OSS server on Ubuntu.

Requirements
------------

Nexus should be running with a EBS snapshots taken periodically of the disk that contains repos.

Nexus OSS is not a stateless server! Nor it can be load-balanced easily. So prepare to be able to restore whole thing with a snapshot (not covered in this example).

Role Variables
--------------

Set required variables in roles/nexus/vars/main.yml, nothing special there.

Dependencies
------------

Use molecule for local development. Tests require rspec/serverspec gems. 

Example Playbook
----------------

playbook.yml comes with a ref to nexus role.

```
- hosts: all
  roles:
      - role: nexus
      ```

License
-------

BSD

Author Information
------------------
Roman Naumenko
