# frozen_string_literal: true

title 'AWS - test cloudwatch subscription'

# load data from Terraform output
content = inspec.profile.file('terraform-outputs.json')
params  = JSON.parse(content)

LOG_GROUP_NAME = params['log_group_name']['value']

control 'test-aws-cloudwatch-subscription' do
  impact 0.8
  title 'Ensure AWS cloudwatch subscription filter exists'
  desc 'Fail when AWS cloudwatch subscription filter  doesnt exist or not properly configured'
  describe aws_cloudwatchlogs_subscription_filters(log_group_name: LOG_GROUP_NAME) do
    it { should exist }
  end
end