require 'bundler'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks
RSpec::Core::RakeTask.new do |rspec|
  rspec.pattern = ENV['SPEC'] || 'spec/**/*_spec.rb'
end
