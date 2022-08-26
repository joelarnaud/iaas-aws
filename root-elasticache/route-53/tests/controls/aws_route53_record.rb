title 'AWS - Test Route 53 Record'

# Load data from Terraform output.
content = inspec.profile.file('terraform-outputs.json')
params = JSON.parse(content)

RECORD_FQDN = params['record_fqdn']['value']
HOSTED_ZONE_ID = params['hosted_zone_id']['value']

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