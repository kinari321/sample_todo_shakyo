.PHONY: hello
hello: ## echo
	echo Hello

###############
# nginxまわり
###############
.PHONY: nginx-copy-conf
nginx-copy-conf: ## nginx.confをコピーして上書き
	sudo cp ./nginx/nginx.conf /etc/nginx/nginx.conf

.PHONY: nginx-restart
nginx-restart: ## nginxの再起動
	sudo systemctl restart nginx

.PHONY: nginx
nginx: ## nginxのセットアップ
	make nginx-copy-conf
	make nginx-restart

###############
# デプロイまわり
###############
.PHONY: kill-app-process
kill-app-process: ## ローカルのアプリプロセスを殺す
	(kill $(shell lsof -i :8080 -t)) || echo ":8080で動いてるプロセスはありません"

.PHONY: build-app
build-app: ## アプリのビルド
	go build ./main.go

.PHONY: run-app-with-background
run-app-with-background: ## アプリを起動
	./main &

.PHONY: deploy
deploy: ## アプリをデプロイ
	make kill-app-process
	make build-app
	make run-app-with-background
	curl localhost

################################################################################
# マクロ
################################################################################
# Makefileの中身を抽出してhelpとして1行で出す
# $(1): Makefile名
define help
  grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(1) \
  | grep --invert-match "## non-help" \
  | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
endef

################################################################################
# タスク
################################################################################
.PHONY: help
help: ## Make タスク一覧
	@echo '######################################################################'
	@echo '# Makeタスク一覧'
	@echo '# $$ make XXX'
	@echo '# or'
	@echo '# $$ make XXX --dry-run'
	@echo '######################################################################'
	@echo $(MAKEFILE_LIST) \
	| tr ' ' '\n' \
	| xargs -I {included-makefile} $(call help,{included-makefile})