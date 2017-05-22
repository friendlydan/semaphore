include makes/env.mk
include makes/local.mk
include makes/docker.mk

OPEN_BROWSER =

.PHONY: docker-bench
docker-bench: ARGS = -benchmem
docker-bench: docker-bench-1.7
docker-bench: docker-bench-1.8
docker-bench: docker-bench-latest

.PHONY: docker-check
docker-check: ARGS = --vendor --deadline=1m ./...
docker-check: docker-tool-gometalinter

.PHONY: docker-pull
docker-pull: docker-pull-1.7
docker-pull: docker-pull-1.8
docker-pull: docker-pull-latest
docker-pull: docker-pull-tools
docker-pull: PRUNE = --force
docker-pull: docker-clean

.PHONY: docker-test
docker-test: docker-test-1.7
docker-test: docker-test-1.8
docker-test: docker-test-latest

.PHONY: docker-test-with-coverage
docker-test-with-coverage: docker-test-with-coverage-1.7
docker-test-with-coverage: docker-test-with-coverage-1.8
docker-test-with-coverage: docker-test-with-coverage-latest

.PHONY: pull-github-tpl
pull-github-tpl:
	rm -rf .github
	(git clone git@github.com:kamilsk/shared.git .github && cd .github && git checkout github-tpl-go-v1 \
	  && echo 'github templates at revision' $$(git rev-parse HEAD) && rm -rf .git)

.PHONY: pull-makes
pull-makes:
	rm -rf makes
	(git clone git@github.com:kamilsk/shared.git makes && cd makes && git checkout makefile-go-v1 \
	  && echo 'makes at revision' $$(git rev-parse HEAD) && rm -rf .git)

.PHONY: research
research: COMMAND = -y research.yml install
research: ARGS    = --strip-vendor
research: docker-tool-glide
research:
	rm -rf .glide
