require 'spec_helper'

describe 'sendmail::define' do
  let(:title) { 'foobar' }

  let(:facts) do
    { 'operatingsystem' => 'Debian',
      'concat_basedir' => '/tmp'
    }
  end

  context 'with no argument' do
    it do
      should contain_concat__fragment('sendmail_mc-define-foobar') \
              .with_content(/^define\(`foobar', `'\)dnl$/) \
              .that_notifies('Class[sendmail::makeall]')
    end
  end

  context 'with one argument' do
    let(:params) do
      { :expansion => 'foo' }
    end

    it do
      should contain_concat__fragment('sendmail_mc-define-foobar') \
              .with_content(/^define\(`foobar', `foo'\)dnl$/) \
              .that_notifies('Class[sendmail::makeall]')
    end
  end

  context 'with one argument and explicit macro_name' do
    let(:params) do
      { :expansion => 'foo', :macro_name => 'baz' }
    end

    it do
      should contain_concat__fragment('sendmail_mc-define-foobar') \
              .with_content(/^define\(`baz', `foo'\)dnl$/) \
              .that_notifies('Class[sendmail::makeall]')
    end
  end

  context 'with one argument and use_quotes => true' do
    let(:params) do
      { :expansion => 'foo', :use_quotes => true }
    end

    it do
      should contain_concat__fragment('sendmail_mc-define-foobar') \
              .with_content(/^define\(`foobar', `foo'\)dnl$/) \
              .that_notifies('Class[sendmail::makeall]')
    end
  end

  context 'with one argument and use_quotes => false' do
    let(:params) do
      { :expansion => 'foo', :use_quotes => false }
    end

    it do
      should contain_concat__fragment('sendmail_mc-define-foobar') \
              .with_content(/^define\(`foobar', foo\)dnl$/) \
              .that_notifies('Class[sendmail::makeall]')
    end
  end

  context 'with one empty argument' do
    let(:params) do
      { :expansion => '' }
    end

    it do
      should contain_concat__fragment('sendmail_mc-define-foobar') \
              .with_content(/^define\(`foobar', `'\)dnl$/) \
              .that_notifies('Class[sendmail::makeall]')
    end
  end

end