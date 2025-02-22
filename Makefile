.PHONY: setup setup_pipenv install docs-serve update benchmark test test_mypy test_unit test_format test_doctests assert_package_safety publish format enforce_docs
PIPENV_VERBOSITY=-1

setup: setup_pipenv install

setup_pipenv:
	pip install pipenv==2023.2.18

install:
	pipenv install --dev --skip-lock

update:
	pipenv update --dev
	pipenv clean
	pipenv run  pip list --outdated

docs_serve:
	pipenv run mkdocs serve --dev-addr 0.0.0.0:8004

benchmark:
	pipenv run pytest tests -m "benchmarking" -vv --benchmark-save=baseline --benchmark-max-time=10 --benchmark-compare=0001 --benchmark-compare-fail=mean:50% --benchmark-disable-gc

test: test_mypy test_unit enforce_docs test_doctests test_format

test_mypy:
	pipenv run mypy --config-file mypy.ini lagom tests

test_unit:
	pipenv run pytest tests -m "not benchmarking" -vv

test_format:
	pipenv run black --check tests lagom

test_doctests:
	pipenv run  pytest --doctest-modules lagom

assert_package_safety:
	pip freeze | safety check --stdin

publish:
	./scripts/publish.sh

coverage:
	pipenv run pytest tests -vv --cov=lagom --cov-report=html

format:
	pipenv run black tests lagom

enforce_docs:
	pipenv run interrogate --ignore-semiprivate --ignore-magic --ignore-private --fail-under 65 -vv lagom
