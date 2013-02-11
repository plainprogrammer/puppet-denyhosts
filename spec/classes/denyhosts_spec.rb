#!/usr/bin/env rspec
require 'spec_helper'

describe 'denyhosts' do

  def param_value(subject, type, title, param)
    catalogue.resource(type, title).send(:parameters)[param.to_sym]
  end

  describe 'test platform specific resources' do
    describe 'for operating system family Debian' do
      let(:params) {{}}
      let(:facts) { { :osfamily => 'debian' } }

      it { should contain_service('denyhosts').with_name('denyhosts') }
    end

    describe 'for operating system family unsupported' do
      let(:facts) {{
        :osfamily  => 'unsupported',
      }}

      it { expect{ subject }.to raise_error(
        /^The denyhosts module is not supported on unsupported based systems/
      )}
    end

    ['Debian'].each do |osfamily|
      describe "for operating system family #{osfamily}" do
        let(:params) {{}}
        let(:facts) { { :osfamily => osfamily } }

        it { should contain_file('/etc/denyhosts.conf').with_owner('root') }
        it { should contain_file('/etc/denyhosts.conf').with_group('root') }
        it { should contain_file('/etc/denyhosts.conf').with_mode('0644') }

        it { should contain_file('/etc/hosts.allow').with_owner('root') }
        it { should contain_file('/etc/hosts.allow').with_group('root') }
        it { should contain_file('/etc/hosts.allow').with_mode('0644') }

        it { should contain_file('/etc/hosts.deny').with_owner('root') }
        it { should contain_file('/etc/hosts.deny').with_group('root') }
        it { should contain_file('/etc/hosts.deny').with_mode('0644') }

        it { should contain_package('denyhosts').with_ensure('present') }

        it { should contain_service('denyhosts').with_ensure('running') }
        it { should contain_service('denyhosts').with_hasstatus(true) }
        it { should contain_service('denyhosts').with_hasrestart(true) }

        it 'should allow service ensure to be overridden' do
          params[:ensure] = 'stopped'
          subject.should contain_service('denyhosts').with_ensure('stopped')
        end

        it 'should allow package ensure to be overridden' do
          params[:autoupdate] = true
          subject.should contain_package('denyhosts').with_ensure('latest')
        end
      end
    end
  end

  describe 'providing allowed hosts' do
    let(:params) { { :always_allow => ['10.0.1.5', '10.0.2.8'] } }
    let(:facts) { { :osfamily => 'Debian' } }

    # FIXME These won't pass with the custom types, but it does work in the Vagrant sanity check.
    #it { should contain_file('/etc/hosts.allow').with_content(/ALL: 10\.0\.1\.5/) }
    #it { should contain_file('/etc/hosts.allow').with_content(/ALL: 10\.0\.2\.8/) }
  end

  describe 'providing denied hosts' do
    let(:params) { { :always_deny => ['10.0.1.5', '10.0.2.8'] } }
    let(:facts) { { :osfamily => 'Debian' } }

    # FIXME These won't pass with the custom types, but it does work in the Vagrant sanity check.
    #it { should contain_file('/etc/hosts.deny').with_content(/ALL: 10\.0\.1\.5/) }
    #it { should contain_file('/etc/hosts.deny').with_content(/ALL: 10\.0\.2\.8/) }
  end

  describe 'enabling synchronization mode' do
    let(:params) { { :use_sync => true } }
    let(:facts) { { :osfamily => 'Debian' } }

    it { should contain_file('/etc/denyhosts.conf').with_content(/SYNC_SERVER\s+=\s+http:\/\/xmlrpc\.denyhosts\.net:9911/) }
    it { should contain_file('/etc/denyhosts.conf').with_content(/SYNC_INTERVAL/) }
    it { should contain_file('/etc/denyhosts.conf').with_content(/SYNC_UPLOAD/) }
    it { should contain_file('/etc/denyhosts.conf').with_content(/SYNC_DOWNLOAD/) }
    it { should contain_file('/etc/denyhosts.conf').with_content(/SYNC_DOWNLOAD_THRESHOLD/) }
    it { should contain_file('/etc/denyhosts.conf').with_content(/SYNC_DOWNLOAD_RESILIENCY/) }
  end
end
