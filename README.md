# HW-1: Flask app in Docker
Build: `docker build -t hw1:1.0 .`
Run: `docker run -d --name hw1 -p 8000:8000 -e APP_GREETING=Merhaba -v hw1data:/data hw1:1.0`
Test: `curl http://localhost:8000/health` and `curl "http://localhost:8000/reverse?text=docker"`
Stop: `docker rm -f hw1`
