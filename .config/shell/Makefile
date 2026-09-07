.PHONY: sandboxed-claude


sandboxed-claude:
	docker build -t sandboxed-claude --build-arg uid=$(shell id -u) --build-arg docker_gid=$(shell getent group docker | cut -d: -f3) .
