###
Openstack Running
###

A dumb, dumb script + dockerfile to do the following:

* Read a config file listing instances and information about them that SHOULD be running in openstack
* See if they exist via the openstack api.
* Try to ping them
* If either of those fail, force remove/reset-state on them, and recreate.

3 config files:

* Settings.yaml: Defines how often to run, noop mode, etc etc
* auth.yaml: Defines how to connect to openstacks api
* instances.yaml: Hash of instances to be created/watcheid


settings.yaml
-------------

```
---
sleep_seconds: 60
noop_mode: true
clean_puppet_cert: true
puppet_ca: my_puppet_ca.example.com
```


instances.yaml
--------------

```
---
os-docker-12:
  ip: 192.168.4.12
  fqnd: 'os-docker-12.my.domain'
  metadata_path: 'metadata/cloud-init.yaml'
  net_name: 'Docker_Network'
  flavor_name: 'b1.filler'
  image_name: 'RHEL_7.0_bare'
  security_group: 'default'
  key_name: 'matthewn'
  tennant_name: 'admin'
os-docker-13:
  ip: 192.168.4.13
  net_name: 'Docker_Network'
  flavor_name: 'b1.filler'
  image_name: 'RHEL_7.0_bare'
  security_group: 'default'
  key_name: 'matthewn'
  tennant_name: 'admin'
```

auth.yaml 
---------

```
---
user: 'some_admin'
key: 'MYSECRETKEY'
tenant: 'some_tenant'
api: 'http://192.168.1.75:5000/v2.0/'
```
