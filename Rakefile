require 'rake'
require 'rdoc/task'

desc 'Generate documentation for the yamled_acl plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = 'YamledAcl'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

task :default => :spec

