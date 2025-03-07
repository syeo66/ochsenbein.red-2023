help:
	@echo "make build     Build the astro app."
	@echo "make develop   Start the astro app for development."
	@echo "make serve     Build and serve the astro app."
	@echo "make clean     Clean the build artifacts."
	@echo "make format    Format files using prettier."
	@echo "make deploy    Deploy the app to the web."
	@echo "make test      Run tests."

ASTRO=node_modules/.bin/astro
PRETTIER=node_modules/.bin/prettier

build: dist
	@echo "Built!"

develop: node_modules
	${ASTRO} dev

format:
	${PRETTIER} --write "**/*.{js,jsx,ts,tsx,json,md,astro}"

start: develop

serve: build
	${ASTRO} preview

deploy: node_modules
	git switch main  && git push
	git switch stage && git pull && git merge main && git push
	git switch main

clean: node_modules
	rm -rf dist

test: node_modules
	@echo "Write tests!"

######################################################################

dist : node_modules src
	${ASTRO} build

node_modules : package-lock.json package.json
	npm install
	touch node_modules
