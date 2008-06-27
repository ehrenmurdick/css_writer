require 'rake'
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s| 
  s.name = "css_writer"
  s.version = "0.0.2"
  s.author = "Ehren Murdick"
  s.email = "ehren.murdick@gmail.com"
  s.homepage = "http://theedgecase.com"
  s.platform = Gem::Platform::RUBY
  s.summary = "CSS::Writer is css in ruby"
  s.files = FileList["{bin,lib}/**/*"].to_a
  s.require_path = "."
  s.autorequire = "init"
  s.has_rdoc = true
  s.extra_rdoc_files = ["README"]
end

Rake::GemPackageTask.new(spec) do |pkg| 
  pkg.need_tar = true 
end 
