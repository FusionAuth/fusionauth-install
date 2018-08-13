require 'serverspec'

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
  end
end

describe package('passport-backend') do
  it { should be_installed }
end

describe service('passport-backend') do
  it { should_not be_enabled }
  it { should_not be_running }
end

describe package('passport-search-engine') do
  it { should be_installed }
end

describe service('passport-search-engine') do
  it { should_not be_enabled }
  it { should_not be_running }
end

