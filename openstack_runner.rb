#!/usr/bin/env ruby

require 'rubygems'
require 'openstack'
require 'pp'
require 'yaml'

def read_settings()
  settings=YAML.load(File.read('settings.yaml'))
  return settings
end

def read_instances()
  instances=YAML.load(File.read('instances.yaml'))
  return instances
end

def read_auth()
  auth=YAML.load(File.read('auth.yaml'))
  return auth
end

def os_connect(user,key,api,tenant)
  os = OpenStack::Connection.create(:username => user, :api_key => key, :authtenant => tenant, :auth_url => api, :service_type => "compute")
  return os
end


#Test
auth=read_auth()
pp auth

settings=read_settings()
pp settings

instances=read_instances()
pp instances

os=os_connect(auth['user'],auth['key'],auth['api'],auth['tenant'])
pp os
