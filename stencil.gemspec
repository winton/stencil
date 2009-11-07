# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{stencil}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Winton Welsh"]
  s.date = %q{2009-11-06}
  s.default_executable = %q{stencil}
  s.email = %q{mail@wintoni.us}
  s.executables = ["stencil"]
  s.extra_rdoc_files = ["README.markdown"]
  s.files = ["bin", "bin/stencil", "gemspec.rb", "lib", "lib/stencil", "lib/stencil/branches.rb", "lib/stencil/cmd.rb", "lib/stencil/config.rb", "lib/stencil/hash.rb", "lib/stencil/merge.rb", "lib/stencil/msg.rb", "lib/stencil.rb", "MIT-LICENSE", "Rakefile", "README.markdown", "spec", "spec/spec.opts", "spec/spec_helper.rb"]
  s.homepage = %q{http://github.com/winton/stencil}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Project template manager}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httparty>, ["= 0.4.5"])
    else
      s.add_dependency(%q<httparty>, ["= 0.4.5"])
    end
  else
    s.add_dependency(%q<httparty>, ["= 0.4.5"])
  end
end
