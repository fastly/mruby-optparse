MRuby::Gem::Specification.new('mruby-optparse') do |spec|
  spec.license = 'MIT'
  spec.author  = 'Internet Initiative Japan Inc.'

  spec.add_dependency 'mruby-catch-throw'
  spec.add_dependency 'mruby-env'
  spec.add_dependency 'mruby-onig-regexp'
end
