# Copy the yml.tmpl files to .yml if they don't exist
require 'fileutils'

Dir.glob(File.join(File.dirname(File.expand_path(__FILE__)), "*.tmpl")).each do |template|
  file = template.split(".tmpl").first
  FileUtils.cp(template, file) unless File.exists?(file)
end
