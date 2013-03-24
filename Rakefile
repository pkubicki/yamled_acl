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

desc "Build current version as a rubygem"
task :build do
  `gem build yamled_acl.gemspec`
  `mv yamled_acl-*.gem pkg/`
end

desc "Relase current version to rubygems.org"
task :release => :build do
  `git tag -am "Version bump to #{YamledAcl::VERSION}" v#{YamledAcl::VERSION}`
  `git push origin master`
  `git push origin master --tags`
  `gem push pkg/yamled_acl-#{YamledAcl::VERSION}.gem`
end
