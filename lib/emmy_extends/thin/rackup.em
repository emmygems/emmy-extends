config = Emmy::Runner.instance.config
config_ru = File.join(Dir.getwd, "config.ru")

unless File.readable_real?(config_ru)
  puts "Missing #{config_ru} file."
  exit
end

rackup_code = File.read(config_ru)
# can run bundler in rackup.ru
app = eval("Rack::Builder.new { use Fibre::Rack::FiberPool; ( #{rackup_code}\n )}.to_app", TOPLEVEL_BINDING, config_ru)

require 'thin'

puts "Thin web server"
puts "Application starting in #{config.environment}"
puts "Listening on #{config.url}"
Emmy.bind *EmmyExtends::Thin::Controller.new(config, app)
