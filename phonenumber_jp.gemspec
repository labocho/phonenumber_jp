lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "phonenumber_jp/version"

Gem::Specification.new do |spec|
  spec.name          = "phonenumber_jp"
  spec.version       = PhonenumberJp::VERSION
  spec.authors       = ["labocho"]
  spec.email         = ["labocho@penguinlab.jp"]

  spec.summary       = "Hyphenate Japanese phone number"
  spec.description   = "Hyphenate Japanese phone number"
  spec.homepage      = "https://github.com/labocho/phonenumber_jp"
  spec.license       = "MIT"

  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = spec.homepage
    spec.metadata["changelog_uri"] = "https://github.com/labocho/phonenumber_jp/blob/master/CHANGELOG.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r(^exe/)) {|f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 1.16"
  spec.add_development_dependency "rake", ">= 10.0"
  spec.add_development_dependency "rspec", ">= 3.7"
  spec.add_development_dependency "rubocop", ">= 0.76"
end
