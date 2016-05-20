MRuby::Gem::Specification.new('mruby-optparse') do |spec|
  spec.license = 'MIT'
  spec.author  = 'Internet Initiative Japan Inc.'

  spec.add_dependency 'mruby-array-ext',   core: 'mruby-array-ext'
  spec.add_dependency 'mruby-catch-throw', core: 'mruby-catch-throw'
  spec.add_dependency 'mruby-exit',        core: 'mruby-exit'
  spec.add_dependency 'mruby-hash-ext',    core: 'mruby-hash-ext'
  spec.add_dependency 'mruby-proc-ext',    core: 'mruby-proc-ext'
  spec.add_dependency 'mruby-string-ext',  core: 'mruby-string-ext'

  spec.add_dependency 'mruby-env'
  spec.add_dependency 'mruby-onig-regexp'

  spec.add_test_dependency 'mruby-mtest'
end
