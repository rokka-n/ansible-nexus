require 'spec_helper'

describe 'Nexus app is running' do
  describe port('8081') do
    it { should be_listening.on('0.0.0.0').with('tcp') }
  end

  describe process('/opt/nexus/lib/boot/nexus-main.jar') do
    its(:count) { should eq 1 }
  end

  describe service('nexus') do
    it { should be_running }
  end
end

describe user('nexus') do
  it { should exist }
end

describe group('nexus') do
  it { should exist }
end

describe file('/opt/nexus-2.11.1-01/conf/nexus.properties') do
  its(:content) { should match(/application-port=8081/) }
  its(:content) { should match(/application-host=0.0.0.0/) }
  its(:content) { should match('nexus-work=/data/sonatype-work/nexus') }
  its(:content) { should match %r{nexus-webapp-context-path=/nexus} }
end
