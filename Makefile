.PHONY: test docs package upload

VERSION          ?= $(shell git describe --tags --always --dirty)

default: package

clean:
	rm -fr build dist *egg-info .tox/ .cache/ .pytest_cache/ docs/_build/

test:
	pipenv run flake8
	pipenv run coverage run --source=pykube -m py.test
	pipenv run coverage html
	pipenv run coverage report

apidocs:
	# update autodoc, only needs to be run when new modules are added
	pipenv run sphinx-apidoc pykube -o docs/api/ -T --force

docs:
	pipenv run sphinx-build -M html docs docs/_build

package: test
	pipenv run python3 setup.py sdist bdist_wheel
	pipenv run twine check dist/pykube*

upload: package
	pipenv run twine upload dist/pykube*

version:
	sed -i "s/__version__ = .*/__version__ = '${VERSION}'/" pykube/__init__.py
