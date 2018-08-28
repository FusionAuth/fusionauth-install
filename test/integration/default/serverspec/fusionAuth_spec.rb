require 'serverspec'

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
  end
end

describe package('fusionauth-app') do
  it { should be_installed }
end

describe service('fusionauth-app') do
  it { should_not be_enabled }
  it { should_not be_running }
end

describe package('fusionauth-search') do
  it { should be_installed }
end

describe service('fusionauth-search') do
  it { should_not be_enabled }
  it { should_not be_running }
end

