lint:
	bundle exec rubocop

lint-fix:
	bundle exec rubocop -A

watch:
	bin/dev

services:
	docker compose up -d

db-reset:
	docker compose down db -v
	docker compose up db -d
	rm -rf db/schema.rb
	bin/rails db:create db:migrate

dev:
	bundle check || bundle install
	bin/rails db:migrate
	yarn install --frozen-lockfile
	OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES bin/rails s -p 3000
