# # encoding: utf-8

# Inspec test for recipe belfast::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

# Ensure that Nginx is up and running and listening on port 80
describe port(80) do
  it { should be_listening }
end

# Ensure the HTML file is in the correct place
describe file('/usr/share/nginx/html/index.html') do
  it { should exist }
end

# Perform a test against the page to check that
# it is serving the correct file
describe http('http://localhost') do
  its('body') { should include 'Hello Belfast' }
end
