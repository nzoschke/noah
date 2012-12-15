@root = File.expand_path(File.dirname(__FILE__))

run Proc.new { |env|
  index = File.join(@root, Rack::Utils.unescape(env["PATH_INFO"]), "index.html")
  app = File.exists?(index) ? Rack::File.new(index) : Rack::Directory.new(@root)
  app.call(env)
}