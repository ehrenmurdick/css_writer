require 'rake'
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s| 
  s.name = "rcss"
  s.version = "0.0.1"
  s.author = "Ehren Murdick"
  s.email = "ehren.murdick@gmail.com"
  s.homepage = "http://theedgecase.com"
  s.platform = Gem::Platform::RUBY
  s.summary = "RCss: Ruby CSS"
  s.files = FileList["{bin,lib}/**/*"].to_a
  s.require_path = "lib"
  s.autorequire = "rcss"
  s.has_rdoc = true
  s.extra_rdoc_files = ["README"]
end

Rake::GemPackageTask.new(spec) do |pkg| 
  pkg.need_tar = true 
end 
