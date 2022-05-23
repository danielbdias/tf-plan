.PHONY: docs test upload

docs:
	sphinx-apidoc -f -o docs tfplan
	[ -e "docs/_build/html" ] && rm -R docs/_build/html
	sphinx-build docs docs/_build/html

test:
	pytest tests/*.py -sv --disable-warnings 2>/dev/null

test/quiet:
	pytest tests/*.py --quiet --disable-warnings 2>/dev/null

upload:
	[ -e "dist/" ] && rm -Rf dist/
	python3 setup.py sdist bdist_wheel
	twine upload dist/*

experiments/run:
	python3 scripts/tfplan.py tensorplan Navigation-v1 -b 32 -hr 20 -e 200 --optimizer RMSProp -lr 0.05

experiments/debug:
	python3 -m debugpy --listen 0.0.0.0:5678 --wait-for-client scripts/tfplan.py tensorplan Navigation-v1 -b 32 -hr 20 -e 200 --optimizer RMSProp -lr 0.05