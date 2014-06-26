include_recipe "cloud_monitoring::agent"

cloud_monitoring_check "CPU" do
  type "agent.cpu"
  action :create
end

cloud_monitoring_check "Memory" do
  type "agent.memory"
  action :create
end

cloud_monitoring_check "Load average" do
  type "agent.loadavg"
  action :create
end

cloud_monitoring_check "Filesystem - /" do
  type "agent.filesystem"
  action :create
  details(
    :target => "/"
  )
end

cloud_monitoring_check "Network - eth0" do
  type "agent.network"
  action :create
  details(
    :target => "eth0"
  )
end
