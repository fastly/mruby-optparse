require 'rake/clean'

BUILD_CONFIG_FILE = File.expand_path 'tmp/mruby_build_config.rb'
MRUBY_VERSION     = ENV.fetch 'MRUBY_VERSION', '1.2.0'
MRUBY_ROOT        = File.join 'tmp', "mruby-#{MRUBY_VERSION}"
MRUBY_EXE         = "#{MRUBY_ROOT}/bin/mruby"

CLOBBER << 'tmp'

task default: :test

def mruby_rake *tasks
  raise 'BUILD_CONFIG_FILE unset, add tmp/mruby_build_config.rb dependency' if
    BUILD_CONFIG_FILE.empty?

  cd MRUBY_ROOT do
    env = {
      'MRUBY_CONFIG' => BUILD_CONFIG_FILE,
    }

    $stderr.puts "minirake #{tasks.join ' '}" if Rake.application.options.trace

    pid = Process.spawn env, 'ruby', 'minirake', *tasks

    Process.wait pid

    fail 'mruby exited non-zero' unless $?.success?
  end
end

def mruby_bin *args
  sh MRUBY_EXE, *args
end

tests = FileList['test/**/test_*.rb']

desc 'Run tests with mruby'
task test: [:mruby, *tests] do
  mruby_bin(*tests)
end

desc 'Build mruby'
task mruby: MRUBY_EXE

directory 'tmp'

file BUILD_CONFIG_FILE => 'tmp' do |t|
  local_gem = File.expand_path File.dirname __FILE__

  build_config = <<-BUILD_CONFIG
MRuby::Build.new do |conf|
  toolchain :gcc

  conf.gembox 'default'

  conf.gem mgem: 'mtest'
  conf.gem #{local_gem.dump}
end
  BUILD_CONFIG

  File.write BUILD_CONFIG_FILE, build_config
end

mruby_file     = "mruby-#{MRUBY_VERSION}.tar.gz"
mruby_download = "tmp/#{mruby_file}"

file mruby_download => "tmp" do
  sh 'curl', '-s', '-L', '-o', mruby_download,
     '--fail', '--retry', '3', '--retry-delay', '1',
     "https://github.com/mruby/mruby/archive/#{MRUBY_VERSION}.tar.gz"
end

directory MRUBY_ROOT => mruby_download do
  sh 'tar', 'xzf', mruby_download, '-C', 'tmp'
end

task :update_gems do
  Rake::FileList["#{MRUBY_ROOT}/build/mrbgems/*"].each do |gem_dir|
    sh 'git', '-C', gem_dir, 'pull'
  end
end

mruby_deps = Rake::FileList[
  BUILD_CONFIG_FILE,
  MRUBY_ROOT,
  'mrblib/**/*',
]

file MRUBY_EXE => [:update_gems, *mruby_deps] do
  mruby_rake 'all'
end

