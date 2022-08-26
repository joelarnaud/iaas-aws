# frozen_string_literal: true

title 'AWS - test S3'

# load data from Terraform output
content = inspec.profile.file('terraform-outputs.json')
params = JSON.parse(content)

BUCKET_ORIGIN_NAME = params['bucket_id_origin']['value'][0][0][0]
BUCKET_REPLICA_NAME = params['bucket_id_replica']['value'][0][0][0]

control 'test-aws-s3-origin' do
  impact 0.8
  title 'Ensure AWS S3 exists'
  desc 'Fail when AWS S3 origin doesnt exist or not properly configured'
  describe aws_s3_bucket(bucket_name: BUCKET_ORIGIN_NAME) do
    it { should exist }
    it { should_not be_public }
    it { should have_default_encryption_enabled }
    it { should have_versioning_enabled }
    its('region') { should eq 'ca-central-1' }
  end
end

control 'test-aws-s3-replica' do
  impact 0.8
  title 'Ensure AWS S3 exists'
  desc 'Fail when AWS S3 replica doesnt exist or not properly configured'
  describe aws_s3_bucket(bucket_name: BUCKET_REPLICA_NAME) do
    it { should exist }
    it { should_not be_public }
    it { should have_default_encryption_enabled }
    it { should have_versioning_enabled }
    its('region') { should eq 'eu-west-1' }
  end
end