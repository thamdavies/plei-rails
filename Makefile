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
	docker compose up -d --wait --wait-timeout 90 db
	rm -rf db/schema.rb
	bin/rails db:create db:prepare

dev:
	bundle check || bundle install
	bin/rails db:prepare
	yarn install --frozen-lockfile
	bin/rails s -p 1996
