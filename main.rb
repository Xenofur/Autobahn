require "webrick"
require "net/http"
require "uri"

BACKENDS = [
  "http://localhost:3001",
  "http://localhost:3002"
]

current = 0
mutex = Mutex.new

server = WEBrick::HTTPServer.new(
  Port: 8080,
  BindAddress: "0.0.0.0"
)

server.mount_proc "/" do |req, res|
  backend = mutex.synchronize do
    target = BACKENDS[current]
    current = (current + 1) % BACKENDS.length
    target
  end

  uri = URI.join(backend, req.path)
  uri.query = req.query_string if req.query_string

  begin
    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = 2
    http.read_timeout = 5

    request = Net::HTTP::Get.new(uri)
    response = http.request(request)

    res.status = response.code.to_i
    res["Content-Type"] = response["Content-Type"] || "text/plain"
    res.body = response.body
  rescue => e
    res.status = 502
    res.body = "Bad Gateway: #{e.message}"
  end
end

trap("INT") { server.shutdown }

puts "Load balancer listening on http://localhost:8080"
server.start
