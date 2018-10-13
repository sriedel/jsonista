Gem::Specification.new do |spec|
  spec.name = 'jsonista'
  spec.version = '0.0.1'
  spec.author = 'Sven Riedel'
  spec.summary = 'json templating system'
  spec.files = %w[ Gemfile ]
  spec.require_paths = %w[ lib ]
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'm'
  spec.add_development_dependency 'minitest'
end
