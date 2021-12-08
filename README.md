# sinatra_memo
メモを作成、保存することができるアプリです。後からメモを編集することもできます。

## 使い方
このアプリを使用するためには、PostgreSQLのインストール及びDBの作成が必要になります。
インストールが終了し、postgresqlにログイン後、以下のコマンドを実行してください。
1. create database sinatra_memo;
2. \c sinatra_memo;
3. create table memos (
id serial,
title text,
body text,
primary key (id)
);

また、ターミナルで以下のコマンドを実行してください。

1. `$ git clone https://github.com/yatsuhashi168/sinatra_memo.git`
2. `$ cd memo_sinatra`
3. `$ bundle install`
4. `$ ruby main.rb`


実行し終わったら、ブラウザでlocalhost:4567へ移動し、表示を確認してください。

## 環境

- sinatra v2.1.0
- sinatra-contrib v2.1.0
- webrick v1.7.0
- PostgreSQL 14.0
