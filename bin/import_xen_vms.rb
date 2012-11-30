#!/usr/bin/env ../script/runner

require 'xmlrpc/client'

XENHOST = 'citrix1.warnerbros.com'
USER = 'root'
PASS = 'mrkamk'

xen = XMLRPC::Client.new(XENHOST)
session = xen.call('session.login_with_password', USER, PASS)

vm_records = xen.call('VM.get_all_records', session['Value'])

vm_records['Value'].each do |key, val|
  next if val['is_a_template'] == true
  next if val['is_a_control_domain'] == true
  next if val['name_label'].include?('Control domain')
  next if val['name_label'].include?('ZZ_')

  vs = VirtualServer.find_or_create_by_uuid(val['uuid'])
  vs.name = "xen_#{val['name_label']}"
  vs.hostname = vs.name
  vs.vm_power_state = val['power_state']
  vs.vm_memory_target = val['memory_target']
  vs.vm_memory_dynamic_max = val['memory_dynamic_max']
  vs.vm_memory_dynamic_min = val['memory_dynamic_min']
  vs.vm_memory_static_min = val['memory_static_min']
  vs.vm_memory_static_max = val['memory_static_max']
  vs.vm_vcpus_max = val['VCPUs_max']
  vs.vm_vcpus_at_startup = val['VPUs_at_startup']
  
  if vs.valid?
    puts "Saving #{vs.name}"
    begin
      vs.save
    rescue
      puts "Error saving: #{$!}"
    end
  else
    puts vs.errors.inspect
  end
end
