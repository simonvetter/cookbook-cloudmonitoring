actions :create

attribute :label, :kind_of => String, :name_attribute => true
attribute :type, :kind_of => String
attribute :target_alias, :kind_of => String
attribute :target_hostname, :kind_of => String
attribute :target_resolver, :kind_of => String
attribute :monitoring_zones, :kind_of => Array
attribute :details, :kind_of => Hash
attribute :notification_plan_id, :kind_of => Array
