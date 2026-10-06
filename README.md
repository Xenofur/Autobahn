# Autobahn
A simple Ruby HTTP load balancer using only the standard library.
# Requirements
Ruby 3.x
# Usage
Start two backend servers:
```
ruby backend.rb 3001
ruby backend.rb 3002
```
Then start Autobahn
```
ruby main.rb
```
Rubahn listens on:
```
http://localhost:8080
```
Requests are distributed between:
```
http://localhost:3001
http://localhost:3002
```
For example:
```
curl http://localhost:8080/
```
Configuration
Edit the backend list in load_balancer.rb:
```
BACKENDS = [
  "http://localhost:3001",
  "http://localhost:3002"
]
```
