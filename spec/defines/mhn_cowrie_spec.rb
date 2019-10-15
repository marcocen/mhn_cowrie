require 'spec_helper'

describe 'mhn_cowrie' do
  let(:title) { 'namevar' }
  let(:params) do
    {
      'port' => 22,
      'user' => 'cowrie',
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_class('supervisor') }
      it { is_expected.to contain_package('gcc') }
      it {
        is_expected.to contain_vcsrepo('/opt/cowrie').with(
          'ensure' => 'present',
          'provider' => 'git',
          'source' => 'https://github.com/micheloosterhof/cowrie.git',
          'revision' => '34f8464',
        )
      }
    end
  end
end
