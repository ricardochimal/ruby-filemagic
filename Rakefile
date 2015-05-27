
require 'pathname'
require 'rake'
require 'rubygems/package_task'
require 'rdoc/task'
require 'rake/testtask'

gemspec = eval( File.read('ruby-filemagic.gemspec') )

desc 'Default task (test)'
task :default => [:test]

desc 'Run unit tests'
Rake::TestTask.new('test') do |test|
  test.test_files = [ File.join( 'test', 'regress.rb' ) ]
  test.libs = [ File.dirname(Pathname.new(__FILE__).realpath) ]
  test.verbose = true
  test.warning = true
end

desc 'Clean up'
task :clean do
  FileUtils.rm([
               "Makefile",
               "mkmf.log",
               "filemagic.so",
               "filemagic.o",
               "core",
               "ruby-filemagic-#{gemspec.version}.gem"],
               :force => true )
end

desc 'Build'
task :build do
  system( 'ruby extconf.rb' )
  system( 'make' )
end

desc 'RDoc Documentation'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_files.add %w[ README TODO AUTHORS filemagic.c ]
  rdoc.main = 'README'
  rdoc.title = 'Ruby FileMagic Library Binding'
end

desc 'Install'
task :install do
  system( 'make install' )
end

task :gem
Gem::PackageTask.new(gemspec) do |pkg|
  pkg.need_tar = true
end

