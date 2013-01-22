require 'rubygems'
require 'puppetlabs_spec_helper/rake_tasks'

require 'vagrant'

desc 'Vagrant Reality Check'
task :vagrant do
  puts '-------------------------------------'
  puts 'About to run Vagrant Reality Check...'
  puts "-------------------------------------\n\n"

  system('vagrant up')

  puts "\n\n----------------------------------------------------------"
  puts 'Inspect the runs above to make sure they happened cleanly!'
  puts "----------------------------------------------------------\n\n"

  puts '------------------------------------------'
  puts 'Cleaning up after Vagrant Reality Check...'
  puts '------------------------------------------'

  env = Vagrant::Environment.new
  env.cli('destroy', '--force')

  puts 'Done!'
end
