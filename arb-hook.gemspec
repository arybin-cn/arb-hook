# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'arb/hook/version'

Gem::Specification.new do |spec|
  spec.name          = "arb-hook"
  spec.version       = Arb::Hook::VERSION
  spec.authors       = ["arybin"]
  spec.email         = ["arybin@163.com"]

  spec.summary       = %q{Class patch that helps to "hook" specific methods of specific classes.}
  spec.description   = %q{To hook a method(s), invoke Module#hook_method(s) with a block, then the block will be executed before the method with arguments passed to this method.}
  spec.homepage      = "https://github.com/arybin-cn/arb-hook"


  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
end
