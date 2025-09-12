SHELL :=/bin/bash -e -o pipefail
PWD   := $(shell pwd)

.DEFAULT_GOAL := all
.PHONY: all
all: ## build pipeline
all: setup format analyze test dartdoc

.PHONY: precommit
precommit: ## validate the branch before commit
precommit: all

.PHONY: ci
ci: ## CI build pipeline
ci: analyze test

.PHONY: git-hooks
git-hooks: ## install git hooks
	@git config --local core.hooksPath .githooks/

.PHONY: help
help:
	@echo 'Usage: make <OPTIONS> ... <TARGETS>'
	@echo ''
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: setup
setup: ## setup environment
	$(call print-target)
	@if command -v dart > /dev/null; then \
		dart --disable-analytics; \
	elif command -v fvm > /dev/null; then \
		fvm dart --disable-analytics; \
		fvm flutter config --no-analytics --enable-android --enable-web; \
	else \
		echo "Warning: Neither dart nor fvm found. Please install Dart SDK or Flutter."; \
	fi
	$(call get)

.PHONY: version
version: ## show current dart/flutter version
	$(call print-target)
	@if command -v dart > /dev/null; then \
		dart --version; \
	elif command -v fvm > /dev/null; then \
		fvm flutter --version; \
	else \
		echo "Neither dart nor fvm found"; \
	fi

.PHONY: get
get: ## get dependencies
	$(call print-target)
	@if command -v dart > /dev/null; then \
		dart pub get; \
	elif command -v fvm > /dev/null; then \
		fvm flutter pub get; \
	else \
		echo "Neither dart nor fvm found"; \
	fi

.PHONY: upgrade
upgrade: get ## upgrade dependencies
	$(call print-target)
	@if command -v dart > /dev/null; then \
		dart pub upgrade; \
	elif command -v fvm > /dev/null; then \
		fvm flutter pub upgrade; \
	else \
		echo "Neither dart nor fvm found"; \
	fi

.PHONY: outdated
outdated: ## check for outdated dependencies
	$(call print-target)
	@if command -v dart > /dev/null; then \
		dart pub outdated; \
	elif command -v fvm > /dev/null; then \
		fvm flutter pub outdated; \
	else \
		echo "Neither dart nor fvm found"; \
	fi

.PHONY: fix
fix: get ## format and fix code
	$(call print-target)
	@if command -v dart > /dev/null; then \
		dart format .; \
		dart fix --apply lib/; \
		dart fix --apply test/; \
	elif command -v fvm > /dev/null; then \
		fvm dart format .; \
		fvm dart fix --apply lib/; \
		fvm dart fix --apply test/; \
	else \
		echo "Neither dart nor fvm found"; \
	fi

.PHONY: format
format: fix

.PHONY: fmt
fmt: fix

.PHONY: clean
clean: ## remove files created during build pipeline
	$(call print-target)
	@if command -v dart > /dev/null; then \
		dart clean; \
	elif command -v fvm > /dev/null; then \
		fvm flutter clean; \
	fi
	@rm -rf .dart_tool build coverage .flutter-plugins .flutter-plugins-dependencies
	$(call get)

.PHONY: analyze
analyze: get ## check source code for errors and warnings
	$(call print-target)
	@if command -v dart > /dev/null; then \
		dart analyze --fatal-infos --fatal-warnings lib/ test/; \
	elif command -v fvm > /dev/null; then \
		fvm flutter analyze --fatal-infos --fatal-warnings lib/ test/; \
	else \
		echo "Neither dart nor fvm found"; \
	fi

.PHONY: check
check: analyze

.PHONY: lint
lint: analyze

.PHONY: test
test: ## run tests
	$(call print-target)
	@if command -v dart > /dev/null; then \
		dart test --concurrency=4 --reporter=compact --timeout=30s; \
	elif command -v fvm > /dev/null; then \
		fvm flutter test --color --coverage --concurrency=50 --platform=tester --reporter=compact --timeout=30s; \
	else \
		echo "Neither dart nor fvm found"; \
	fi

.PHONY: test-coverage
test-coverage: test ## run tests with coverage
	$(call print-target)
	@if command -v dart > /dev/null; then \
		dart test --coverage=coverage; \
		dart run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --packages=.dart_tool/package_config.json --report-on=lib; \
	fi

.PHONY: coverage
coverage: test-coverage ## generate coverage report
	$(call print-target)
	@if [ -f coverage/lcov.info ]; then \
		lcov --list coverage/lcov.info; \
	else \
		echo "No coverage file found. Run 'make test-coverage' first."; \
	fi

.PHONY: diff
diff: ## git diff
	$(call print-target)
	@git diff --exit-code
	@RES=$$(git status --porcelain) ; if [ -n "$$RES" ]; then echo $$RES && exit 1 ; fi

.PHONY: dartdoc
dartdoc: ## generate dart documentation
	$(call print-target)
	@rm -rf doc
	@if command -v dart > /dev/null; then \
		dart doc .; \
	elif command -v fvm > /dev/null; then \
		fvm dart doc .; \
	else \
		echo "Neither dart nor fvm found"; \
	fi

.PHONY: publish-dry-run
publish-dry-run: ## dry run package publication
	$(call print-target)
	@if command -v dart > /dev/null; then \
		dart pub publish -n; \
	elif command -v fvm > /dev/null; then \
		fvm dart pub publish -n; \
	else \
		echo "Neither dart nor fvm found"; \
	fi

.PHONY: releasedryrun
releasedryrun: publish-dry-run

.PHONY: publish
publish: ## publish package to pub.dev
	$(call print-target)
	@if command -v dart > /dev/null; then \
		dart pub publish; \
	elif command -v fvm > /dev/null; then \
		fvm dart pub publish; \
	else \
		echo "Neither dart nor fvm found"; \
	fi

.PHONY: build-example
build-example: ## build example application
	$(call print-target)
	@cd example && make build

.PHONY: run-example
run-example: ## run example application
	$(call print-target)
	@cd example && make run

define print-target
    @printf "Executing target: \033[36m$@\033[0m\n"
endef