title 'AWS - test Lambda'

# load data from Terraform output
content = inspec.profile.file('terraform-outputs.json')
params = JSON.parse(content)

control 'test-aws-lambda' do
  impact 0.8
  title 'Ensure AWS Lambda exist'
  desc 'Fail when AWS Lambda doesnt exist'
  describe aws_lambda(params['lambda_function_name']['value']) do
    it { should exist }
    its ('function_arn') { should eq params['lambda_function_arn']['value'] }
    its ('handler') { should eq params['lambda_function_handler']['value'] }
    its ('runtime') { should eq params['lambda_function_runtime']['value'] }
  end
end