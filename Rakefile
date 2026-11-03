begin
  require "bundler/gem_tasks"
rescue LoadError
end

require "rake/testtask"
Rake::TestTask.new(:test) do |t|
  t.libs << "test/lib"
  t.ruby_opts << "-rhelper"
  t.test_files = FileList["test/**/test_*.rb"]
end

namespace :rbs do
  Rake::TestTask.new(:test) do |t|
    t.libs << "test_sig"
    t.test_files = FileList["test_sig/test_*.rb"].exclude("test_sig/test_helper.rb")
  end

  desc "Update RBS comments"
  task :annotate do
    require "tmpdir"

    Dir.mktmpdir do |tmpdir|
      sh("rdoc --ri --output #{tmpdir}/doc --root=. lib")
      sh("rbs annotate --no-system --no-gems --no-site --no-home -d #{tmpdir}/doc sig")
    end
  end
end

require "rdoc/task"
RDoc::Task.new do |doc|
  doc.main   = "README.md"
  doc.title  = "Logger -- Ruby Standard Logger"
  doc.rdoc_files = FileList.new %w[README.md lib BSDL COPYING]
  doc.rdoc_dir = "html"
end

task "gh-pages" => :rdoc do
  %x[git checkout gh-pages]
  require "fileutils"
  FileUtils.rm_rf "/tmp/html"
  FileUtils.mv "html", "/tmp"
  FileUtils.rm_rf "*"
  FileUtils.cp_r Dir.glob("/tmp/html/*"), "."
end

task :default => :test
