###
Openstack Running
###

A dumb, dumb script + dockerfile to do the following:

* Read a config file listing instances and information about them that SHOULD be running in openstack
* See if they exist via the openstack api.
* Try to ping them
* If either of those fail, force remove/reset-state on them, and recreate.

3 config files:

* Settings.yml: Defines how often to run, noop mode, etc etc
* auth.yml: Defines how to connect to openstacks api
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
