title 'AWS - test Lambda'

# load data from Terraform output
content = inspec.profile.file('terraform-outputs.json')
params = JSON.parse(content)

BUCKET_NAME = params['source_code_bucket']['value']
OBJECT_KEY_MOVE_FILE = params['source_code_move_file_id']['value']

control 'test-aws-lambda' do
  impact 0.8
  title 'Ensure AWS Lambda exist'
  desc 'Fail when AWS Lambda doesnt exist'
  describe aws_s3_bucket_object(bucket_name: BUCKET_NAME, key: OBJECT_KEY_MOVE_FILE) do
    it { should exist }
    it { should_not be_public }
  end
end