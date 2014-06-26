# Description
Simple cloud monitoring cookbook using agent side configuration to set
up agent and remote checks.

Main recipes:
 - ramxon: installs the raxmon cli tool.
 - agent: installs and configures the agent
 - basic_agent_checks: drops yaml files for cpu, mem,
   load average, filesystem and network checks in the agent
   configuration directory.

The agent token is obtained from the rackspace/cloud data bag.
By default, agent ids are set to the machine's hostname.

Templates for a few check types are included.
Checks can be configured with the cloud_monitoring_check resource
like so:
```
cloud_monitoring_check "Ping - ipv6" do
  type "remote.ping"
  target_alias "public0_v6"
  monitoring_zones ["mzlon", "mziad", "mzhkg"]
  details(
    :count => 10
  )
  action :create
end
```
This will set up an ipv6 ping check targetting the public0_v6 ip
address registered on the entity, using 10 pings per check, and
set up a packet loss alarm using the default notification plan.

```
cloud_monitoring_check "api version check - ipv4" do
  type "remote.http"
  target_hostname node['fqdn']
  target_resolver "IPv4"
  monitoring_zones monitoring_zones
  details(
    :url => "https://" + node['fqdn'] + '/api/v1/version',
    :expected_code => "200",
    :notification_plan_id => "npF4k3N0tf"
  )
  action :create
end
```
This second example will set up an https check using https://my.hosts.fqdn/api/v1/version
over ipv4 and set up two alarms, the first one monitoring the HTTP response
code and the second monitoring the TLS expiry date.
