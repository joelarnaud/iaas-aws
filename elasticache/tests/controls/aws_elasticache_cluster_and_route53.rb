title 'AWS - Test ElastiCache Redis Cluster (Replication Group) and Route 53 Record'

# Load data from Terraform output.
content = inspec.profile.file('terraform-outputs.json')
params = JSON.parse(content)

REPLICATION_GROUP_NODES_ID = params['replication_group_nodes_id']['value']
REPLICATION_GROUP_ID = params['replication_group_id']['value']
NODES_NUMBER = params['nodes_number']['value']

RECORD_FQDN = params['record_fqdn']['value']
HOSTED_ZONE_ID = params['hosted_zone_id']['value']

control 'test-aws-elasticache-cluster' do
  impact 0.8
  title 'Ensure that the primary AWS ElastiCache cluster\'s (replication group) nodes are correctly configured'
  desc 'Fail when the primary AWS ElastiCache cluster\'s (replication group) nodes don\'t exist or are not configured properly'
  REPLICATION_GROUP_NODES_ID.each do | node_id |
    describe aws_elasticache_cluster(cache_cluster_id: node_id) do
      it { should exist }
      its('status') { should eq 'available' }
      its('engine') { should eq 'redis' }
      its('engine_version') { should match(/^6.\d.\d/) }
      it { should be_encrypted_at_rest }
      it { should be_encrypted_at_transit }
      its('auto_minor_version_upgrade') { should eq true }
      its('auth_token_enabled') { should eq true }
      its('ports.values.first') { should eq 6379 }
    end
  end
end

control 'test-aws-elasticache-replication-group' do
  impact 0.8
  title 'Ensure that the primary AWS ElastiCache replication group (cluster) is correctly configured'
  desc 'Fail when the primary AWS ElastiCache replication group (cluster) doesn\'t exist or is not configured properly'
  describe aws_elasticache_replication_group(replication_group_id: REPLICATION_GROUP_ID) do
    it { should exist }
    its('status') { should eq 'available' }
    its('cluster_enabled') { should eq true }
    it { should be_encrypted_at_rest }
    it { should be_encrypted_at_transit }
    its('automatic_failover') { should eq 'enabled' }
    its('multi_az') { should eq 'enabled' }
    its('auth_token_enabled') { should eq true }
    its('kms_key_id') { should_not be_nil }
    its('configuration_endpoint.port') { should eq 6379 }
    its('member_clusters.count') { should eq NODES_NUMBER }
  end
end

control 'test-aws-route53-record-sets' do
  impact 0.8
  title 'Ensure that the Route 53 record for the ElastiCache Redis cluster has been well created'
  desc 'Fail when the Route 53 record for the ElastiCache Redis cluster doesn\'t exist or is not configured properly'
  describe aws_route53_record_sets(hosted_zone_id: HOSTED_ZONE_ID).table.find { | record | record[:name].include?(RECORD_FQDN) } do
    it { should_not be_nil }
    its([:type]) { should eq 'CNAME' }
    its([:ttl]) { should eq 300 }
  end
end