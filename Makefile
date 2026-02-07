.PHONY: install test lint format build check libdoc clean

ROBOT_FILES := $(wildcard tests/test_*.robot)

install:
	pip install -e .

test: install
	python -m robot --outputdir output $(ROBOT_FILES)

lint:
	ruff check src/ tests/
	ruff format --check src/
	prek

format:
	ruff check --fix src/ tests/
	ruff format src/

build: clean lint
	pip install build
	python -m build

check: build
	pip install twine
	twine check dist/*

libdoc: install
	python -m robot.libdoc RobotLibrary RobotLibrary.html

clean:
	rm -rf output/ dist/ build/ src/*.egg-info
	rm -f RobotLibrary.html
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
