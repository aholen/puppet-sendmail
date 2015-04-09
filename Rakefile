require 'rubygems'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'

PuppetLint.configuration.fail_on_warnings = true
PuppetLint.configuration.send('relative')
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.send('disable_class_inherits_from_params_class')
PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", "pkg/**/*.pp"]

task :augparse do
  augparse = 'augparse -Ilib/augeas/lenses '
  # A simple task to run augparse on all my Augeas tests
  FileList['lib/augeas/lenses/tests/*.aug'].each do |file|
    system augparse + file
  end
end
