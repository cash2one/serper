path = File.expand_path('..',__FILE__)
gem_name = File.basename(Dir["#{path}/*.gemspec"].first).sub(/\.gemspec$/,'')

puts "Installing gem #{gem_name}"
puts "Gem source path is #{path}"
puts `
cd #{path}
rm #{gem_name}-*.gem
echo '#{gem_name}-*.gem deleted'
gem build #{gem_name}.gemspec
gem uninstall #{gem_name} -x -a -I
gem install #{gem_name}-*.gem

`
puts "#{gem_name} gem installed successfully!!!"
