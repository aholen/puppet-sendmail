require 'spec_helper'

describe 'sendmail::mc::ostype' do
  context 'on Debian' do
    let(:title) { 'debian' }

    it {
      should contain_concat__fragment('sendmail_mc-ostype-debian') \
              .with_content(/^OSTYPE\(`debian'\)dnl$/) \
              .with_order('05') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'on RedHat' do
    let(:title) { 'redhat' }

    it {
      should contain_concat__fragment('sendmail_mc-ostype-redhat') \
              .with_content(/^OSTYPE\(`redhat'\)dnl$/) \
              .with_order('05') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end
end
