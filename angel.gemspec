require_relative "lib/angel/version"

Gem::Specification.new do |spec|
  spec.name        = "angel"
  spec.version     = Angel::VERSION
  spec.authors     = ["Greg Mikeska"]
  spec.email       = ["gmikeska07@gmail.com"]
  spec.homepage    = "http://github.com/gmikeska/angel_gui"
  spec.summary     = "Classes and helpers to enable runtime-configurable ViewComponents"
  spec.description = "Classes and helpers to enable runtime-configurable ViewComponents"
    spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage + "/CHANGELOG.MD"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['lib/**/*'] + %w[Rakefile README.md]
  end

  spec.require_paths = ["lib"]


  spec.add_dependency "view_component", "~> 2.74.1"
  spec.add_dependency "sass-rails"
  spec.add_dependency "supports_pointer"
  spec.add_dependency "bootstrap_form"
  spec.add_dependency 'rails', '~> 7.0', '>= 7.0.4'
  spec.add_development_dependency "falcon"
  spec.add_development_dependency "better_errors"
  spec.add_development_dependency "binding_of_caller"
  spec.add_development_dependency "faker"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "importmap-rails"
  spec.add_development_dependency "turbo-rails"
  spec.add_development_dependency "hotwire-rails"

end
