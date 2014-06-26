cloud_monitoring_check "Network - eth1" do
  type "agent.network"
  action :create
  details(
    :target => "eth1"
  )
end
