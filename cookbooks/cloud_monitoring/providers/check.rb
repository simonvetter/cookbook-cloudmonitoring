confd = "/etc/rackspace-monitoring-agent.conf.d"

action :create do
  service "rackspace-monitoring-agent" do
    supports :restart => true
    action :nothing
  end

  type = new_resource.type
  label = new_resource.label
  notification_plan_id = new_resource.notification_plan_id || node[:cloud_monitoring][:default_notification_plan_id]
  details = new_resource.details
  target_alias = new_resource.target_alias
  target_hostname = new_resource.target_hostname
  target_resolver = new_resource.target_resolver
  monitoring_zones = new_resource.monitoring_zones || []

  if notification_plan_id == nil then
    raise "one of notification_plan_id or node[:cloud_monitoring][:default_notification_plan_id] must be defined"
  end

  if type == nil then
    raise "check type cannot be null"
  end

  if type =~ /remote/ && monitoring_zones.count === 0 then
    raise "monitoring_zones must be defined for remote checks"
  end

  directory confd do
    owner "root"
    group "root"
    mode "0755"
    recursive true
    action :create
  end

  if type === "agent.cpu" then
    template "#{confd}/cpu.yaml" do
      source "confd/cpu.yaml.erb"
      owner "root"
      group "root"
      mode "0644"
      action :create
      variables(
        :label => label,
        :notification_plan_id => notification_plan_id
      )
      notifies :restart, resources(:service => "rackspace-monitoring-agent"), :delayed
    end
  elsif type === "agent.filesystem" then
    template "#{confd}/filesystem.yaml" do
      source "confd/filesystem.yaml.erb"
      owner "root"
      group "root"
      mode "0644"
      action :create
      variables(
        :label => label,
        :notification_plan_id => notification_plan_id,
        :target => details[:target]
      )
      notifies :restart, resources(:service => "rackspace-monitoring-agent"), :delayed
    end
  elsif type === "agent.loadavg" then
    template "#{confd}/loadavg.yaml" do
      source "confd/loadavg.yaml.erb"
      owner "root"
      group "root"
      mode "0644"
      action :create
      variables(
        :label => label,
        :notification_plan_id => notification_plan_id
      )
      notifies :restart, resources(:service => "rackspace-monitoring-agent"), :delayed
    end
  elsif type === "agent.memory" then
    template "#{confd}/memory.yaml" do
      source "confd/memory.yaml.erb"
      owner "root"
      group "root"
      mode "0644"
      action :create
      variables(
        :label => label,
        :notification_plan_id => notification_plan_id
      )
      notifies :restart, resources(:service => "rackspace-monitoring-agent"), :delayed
    end
  elsif type === "agent.network" then
    id = details[:target]
    template "#{confd}/network.#{details[:target]}.yaml" do
      source "confd/network.yaml.erb"
      owner "root"
      group "root"
      mode "0644"
      action :create
      variables(
        :label => label,
        :notification_plan_id => notification_plan_id,
        :target => details[:target]
      )
      notifies :restart, resources(:service => "rackspace-monitoring-agent"), :delayed
    end
  elsif type === "remote.ping" then
    template "#{confd}/ping-#{label.gsub(' ', '').gsub('/', '').downcase}.yaml" do
      source "confd/ping.yaml.erb"
      owner "root"
      group "root"
      mode "0644"
      action :create
      variables(
        :label => label,
        :notification_plan_id => notification_plan_id,
        :target_alias => target_alias,
        :target_hostname => target_hostname,
        :target_resolver => target_resolver,
        :count => details[:count],
        :monitoring_zones => monitoring_zones
      )
      notifies :restart, resources(:service => "rackspace-monitoring-agent"), :delayed
    end
  elsif type === "remote.http" then
    template "#{confd}/http-#{label.gsub(' ', '').gsub('/', '').downcase}.yaml" do
      source "confd/http.yaml.erb"
      owner "root"
      group "root"
      mode "0644"
      action :create
      variables(
        :label => label,
        :notification_plan_id => notification_plan_id,
        :target_alias => target_alias,
        :target_hostname => target_hostname,
        :target_resolver => target_resolver,
        :count => details[:count],
        :url => details[:url],
        :expected_code => details[:expected_code],
        :monitoring_zones => monitoring_zones
      )
      notifies :restart, resources(:service => "rackspace-monitoring-agent"), :delayed
    end
  else
    raise 'unsupported check type.' + type
  end
end
