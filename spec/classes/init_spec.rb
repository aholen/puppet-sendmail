require 'spec_helper'

describe 'sendmail' do

  context 'On Debian with defaults' do
    it {
      should contain_anchor('sendmail::begin')
      should contain_anchor('sendmail::config')
      should contain_anchor('sendmail::end')

      should contain_class('sendmail')
      should contain_class('sendmail::params')

      should contain_class('sendmail::package') \
              .that_requires('Anchor[sendmail::begin]') \
              .that_comes_before('Anchor[sendmail::config]')

      should contain_class('sendmail::local_host_names')
      should contain_class('sendmail::relay_domains')
      should contain_class('sendmail::trusted_users')
      should contain_class('sendmail::mc')
      should contain_class('sendmail::submit').with(
               'msp_host'                 => '[127.0.0.1]',
               'msp_port'                 => 'MSA',
               'enable_msp_trusted_users' => false,
             )

      should contain_class('sendmail::service') \
              .that_requires('Anchor[sendmail::config]') \
              .that_comes_before('Anchor[sendmail::end]')

      should_not contain_class('sendmail::mc::starttls')
    }
  end

  context "with max_message_size => 42" do
    let(:params) do
      { :max_message_size => '42' }
    end

    it {
      should contain_class('sendmail::mc').with('max_message_size' => '42')
    }
  end

  context 'with local_host_names => www.example.net' do
    let(:params) do
      { :local_host_names => [ 'www.example.net' ] }
    end

    it {
      should contain_class('sendmail::local_host_names').with(
               'local_host_names' => [ 'www.example.net' ],
             )
    }
  end

  context 'with relay_domains => example.net' do
    let(:params) do
      { :relay_domains => [ 'example.net' ] }
    end

    it {
      should contain_class('sendmail::relay_domains').with(
               'relay_domains' => [ 'example.net' ],
             )
    }
  end

  context 'with trusted_users => fred' do
    let(:params) do
      { :trusted_users => [ 'fred' ] }
    end

    it {
      should contain_class('sendmail::trusted_users').with(
               'trusted_users' => [ 'fred' ],
             )
    }
  end

  context 'with trust_auth_mech => PLAIN' do
    let(:params) do
      { :trust_auth_mech => 'PLAIN' }
    end

    it {
      should contain_class('sendmail::mc').with(
               'trust_auth_mech' => 'PLAIN',
             )
    }
  end

  context 'with trust_auth_mech => [ PLAIN, LOGIN ]' do
    let(:params) do
      { :trust_auth_mech => [ 'PLAIN', 'LOGIN' ] }
    end

    it {
      should contain_class('sendmail::mc').with(
               'trust_auth_mech' => [ 'PLAIN', 'LOGIN' ],
             )
    }
  end

  context 'with cf_version => 1.2-3' do
    let(:params) do
      { :cf_version => '1.2-3' }
    end

    it {
      should contain_class('sendmail::mc').with(
               'cf_version' => '1.2-3',
             )
    }
  end

  context 'with version_id => foo' do
    let(:params) do
      { :version_id => 'foo' }
    end

    it {
      should contain_class('sendmail::mc').with(
               'version_id' => 'foo',
             )
    }
  end

  context 'with msp_host => localhost' do
    let(:params) do
      { :msp_host => 'localhost' }
    end

    it {
      should contain_class('sendmail::submit').with(
               'msp_host' => 'localhost',
             )
    }
  end

  context 'with msp_port => 25' do
    let(:params) do
      { :msp_port => '25' }
    end

    it {
      should contain_class('sendmail::submit').with(
               'msp_port' => '25',
             )
    }
  end

  context 'with enable_msp_trusted_users => true' do
    let(:params) do
      { :enable_msp_trusted_users => true }
    end

    it {
      should contain_class('sendmail::submit').with(
               'enable_msp_trusted_users' => true,
             )
    }
  end

  context 'with manage_sendmail_mc => true' do
    let(:params) do
      { :manage_sendmail_mc => true }
    end

    it {
      should contain_class('sendmail::mc') \
              .that_comes_before('Anchor[sendmail::config]') \
              .that_requires('Class[sendmail::package]') \
              .that_notifies('Class[sendmail::service]')
    }
  end

  context 'with manage_sendmail_mc => false' do
    let(:params) do
      { :manage_sendmail_mc => false }
    end

    it {
      should_not contain_class('sendmail::mc')
      should_not contain_class('sendmail::mc::starttls')
    }
  end

  context 'with manage_submit_mc => true' do
    let(:params) do
      { :manage_submit_mc => true }
    end

    it {
      should contain_class('sendmail::submit') \
              .that_comes_before('Anchor[sendmail::config]') \
              .that_requires('Class[sendmail::package]') \
              .that_notifies('Class[sendmail::service]')
    }
  end

  context 'with manage_submit_mc => false' do
    let(:params) do
      { :manage_submit_mc => false }
    end

    it {
      should_not contain_class('sendmail::submit')
    }
  end

  context 'with cipher_list defined' do
    let(:params) do
      { :manage_sendmail_mc => true, :cipher_list => 'foo' }
    end

    it {
      should contain_class('sendmail::mc::starttls').with(
               'cipher_list' => 'foo',
             )
    }
  end

  context 'On unsupported operating system' do
    let(:facts) do
      {
        :operatingsystem => 'VAX/VMS',
        :osfamily        => 'VMS'
      }
    end

    it {
      expect { should compile }.to raise_error(/Unsupported operatingsystem/)
    }
  end
end
