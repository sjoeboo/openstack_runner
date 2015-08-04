#!/usr/bin/env ruby

require 'rubygems'
require 'openstack'
require 'pp'
require 'yaml'
require 'resolv'
require 'ipaddr'
require 'net/ping'

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

def get_instances(os)
  instances=os.servers
  return instances
end

def ping_instances(instances)
unpingable=Hash.new  
instances.each do |name, attrs|
    down=0
    ip=attrs['ip']
    @icmp = Net::Ping::External.new(ip)
    if @icmp.ping
      #puts "#{name} is alive"
    else
      down=1
      puts "#{name} is not alive"
    end
    if down == 1
      unpingable[name] = attrs
    end
  end
  return unpingable
end

def os_get_instance_id(instance_name,os_instances)
  os_instances.each do |i|
    if i[:name] == instance_name
        return i[:id]
    end
  end
end

def os_get_instance(os,id)
  pp os.server(id)
end

#Test

auth=read_auth()
#pp auth

settings=read_settings()
#pp settings

if settings['sleep_seconds'] != nil
  sleep_time = settings['sleep_seconds']
else
  sleep_time = (60*30) 
end

#This will be a loop
exit_requested = false
Kernel.trap( "INT" ) { exit_requested = true }

while !exit_requested

  instances=read_instances()
  #pp instances
  
  os=os_connect(auth['user'],auth['key'],auth['api'],auth['tenant'])
  os_instances=get_instances(os)
  #pp os_instances
  
  puts "Checking on #{instances.length} instances..."
  down=ping_instances(instances)
  #pp down
  
  #If a host is down:
  #
  #If its in openstack, reset state, and delete it. 
  down.each do |name,attrs|
    id=os_get_instance_id(name,os_instances)
    server=os_get_instance(os,id)
    #pp server 
    puts "Deleting/resetting state for server: #{name}"
    #server.delete!
    #Clean/revoke puppet cert
    puppet_cert_cmd1="curl -k -X PUT -H \"Content-Type: text/pson\" --data '{\"desired_state\":\"revoked\"}' https://#{settings['puppet_ca']}:8140/production/certificate_status/#{attrs['fqdn']}"
    puppet_cert_cmd2="curl -k -X DELETE -H \"Accept: pson\" https://#{settings['puppet_ca']}:8140/production/certificate_status/#{attrs['fqdn']}"
    puts puppet_cert_cmd1
    puts puppet_cert_cmd2
  end
  #recreate based on instance info
  
  sleep sleep_time
end
#Loop end
