help:
	@echo "make build     Build the astro app."
	@echo "make develop   Start the astro app for development."
	@echo "make serve     Build and serve the astro app."
	@echo "make clean     Clean the build artifacts."
	@echo "make format    Format files using Vite+."
	@echo "make check     Format, lint and type check using Vite+."
	@echo "make deploy    Deploy the app to the web."
	@echo "make test      Run tests."

VP=vp

build: dist
	@echo "Built!"

develop: node_modules
	${VP} run dev

format: node_modules
	${VP} fmt --write

check: node_modules
	${VP} check

start: develop

serve: build
	${VP} run preview

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
	${VP} run build

node_modules : pnpm-lock.yaml package.json
	${VP} install
	touch node_modules
