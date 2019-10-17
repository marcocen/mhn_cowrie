require 'spec_helper'

describe 'mhn_cowrie' do
  let(:title) { 'namevar' }
  let(:params) do
    {
      :user => 'cowrie',
      :hpf_server => 'mhn-server.local',
      :hpf_id => 'f9a8854e-eaf4-11e9-954a-000c299b8253',
      :hpf_secret => 'qC35iD9Hz339hjlf'
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_class('supervisor') }
      it { is_expected.to contain_class('git') }
      it { is_expected.to contain_package('gcc') }
      it {
        is_expected.to contain_vcsrepo('/opt/cowrie').with(
          'ensure' => 'present',
          'provider' => 'git',
          'source' => 'https://github.com/micheloosterhof/cowrie.git',
          'revision' => '34f8464',
        )
      }
      it { is_expected.to contain_class('python') }
      it { is_expected.to contain_file('/opt/cowrie/etc/cowrie.cfg') }
    end
  end
end
