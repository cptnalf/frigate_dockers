yury: Dockerfile.yury1
	docker image rm cptnalf/frigate-l4t:0.11-beta || true
	docker build -f Dockerfile.yury1 . -t cptnalf/frigate-l4t:0.11-beta
