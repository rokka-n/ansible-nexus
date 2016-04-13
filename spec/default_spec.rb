require 'spec_helper'
require 'yaml'

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

vars = YAML.load(File.open('roles/nexus/vars/main.yml'))
version2 = vars['nexus']['version'].match('^2.')
version3 = vars['nexus']['version'].match('^3.')

describe 'Nexus config settings' do
  context 'For Nexus v2 settings:', if: version2 do
    describe file('/opt/nexus/conf/nexus.properties') do
      its(:content) { should match(/application-port=8081/) }
      its(:content) { should match(/application-host=0.0.0.0/) }
      its(:content) { should match('nexus-work=/data/sonatype-work/nexus') }
      its(:content) { should match %r{nexus-webapp-context-path=/nexus} }
    end
  end

  context 'For Nexus v3 config settings:', if: version3 do
    logging_conf = %(
                   -Djava.util.logging.config.file=
                   etc\/java.util.logging.properties
                    ).gsub(/\s+/, '').strip
    describe file('/opt/nexus/bin/nexus.vmoptions') do
      its(:content) { should match(/^-Xms1200M/) }
      its(:content) { should match(/^-Xmx1200M/) }
      its(:content) { should match(/^-XX:\+UnlockDiagnosticVMOptions/) }
      its(:content) { should match(/^-XX:\+UnsyncloadClass/) }
      its(:content) { should match(/^-Djava.net.preferIPv4Stack=true/) }
      its(:content) { should match(/^-Dkaraf.home=./) }
      its(:content) { should match(/^-Dkaraf.base=./) }
      its(:content) { should match(/^-Dkaraf.etc=etc/) }
      its(:content) { should match(/^#{logging_conf}/) }
      its(:content) { should match(/^-Dkaraf.data=data/) }
      its(:content) { should match(/^-Djava.io.tmpdir=data\/tmp/) }
      its(:content) { should match(/^-Dkaraf.startLocalConsole=false/) }
    end
  end
end
