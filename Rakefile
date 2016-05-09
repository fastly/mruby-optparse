require 'rake/clean'

BUILD_CONFIG_FILE = File.expand_path 'tmp/mruby_build_config.rb'
MRUBY_REPO        = 'https://github.com/mruby/mruby.git'

CLOBBER << 'tmp'

def mruby_rake *tasks
  raise 'BUILD_CONFIG_FILE unset, add tmp/mruby_build_config.rb dependency' if
    BUILD_CONFIG_FILE.empty?

  cd 'tmp/mruby' do
    env = {
      'MRUBY_CONFIG' => BUILD_CONFIG_FILE,
    }

    $stderr.puts "mrake #{tasks.join ' '}" if Rake.application.options.trace

    pid = Process.spawn env, 'ruby', 'minirake', *tasks

    Process.wait pid

    fail 'mruby exited non-zero' unless $?.success?
  end
end

def mruby_bin *args
  sh 'tmp/mruby/bin/mruby', *args
end

task test: %w[mruby] do
  mruby_bin 'test/test_optparse.rb'
end

task mruby: %w[tmp/mruby/bin/mruby]

directory 'tmp'

directory 'tmp/mruby' => %w[tmp] do |t|
  sh 'git', 'clone', '--depth', '1', MRUBY_REPO, t.name
end

file BUILD_CONFIG_FILE => 'tmp' do |t|
  local_gem = File.expand_path File.dirname __FILE__

  build_config = <<-BUILD_CONFIG
MRuby::Build.new do |conf|
  toolchain :gcc

  conf.gembox 'default'

  conf.gem mgem: 'catch-throw'
  conf.gem mgem: 'env'
  conf.gem mgem: 'onig-regexp'
  conf.gem mgem: 'mtest'
  conf.gem #{local_gem.dump}
end
  BUILD_CONFIG

  File.write BUILD_CONFIG_FILE, build_config
end

file 'tmp/mruby/bin/mruby' => %W[#{BUILD_CONFIG_FILE} tmp/mruby] do
  mruby_rake 'all'
end



