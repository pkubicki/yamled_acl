require 'rake'
require 'rake/rdoctask'

desc 'Generate documentation for the yamled_acl plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = 'YamledAcl'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

desc "Run specs with RCov"
RSpec::Core::RakeTask.new(:rcov) do |t|
  t.rcov = true
  t.rcov_opts = %q[--exclude "spec" --text-report]
end

task :default => :spec

