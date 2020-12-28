# InSpec test for recipe asa-chef-example::default

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/

# https://docs.chef.io/inspec/resources/os/#osfamily-names
case os.family
when 'debian', 'redhat', 'suse', 'linux'
  describe service('sftd') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
else
  describe service('sftd') do
    it { should_not be_installed }
  end
end
