require 'webrick'

# Create a simple HTTP server to serve the frontend files
server = WEBrick::HTTPServer.new(
  Port: 8000,
  DocumentRoot: File.join(Dir.pwd, 'public')
)

# Add a shutdown hook
trap('INT') { server.shutdown }

# Start the server
puts "Server started at http://localhost:8000"
puts "Press Ctrl+C to stop"
server.start 