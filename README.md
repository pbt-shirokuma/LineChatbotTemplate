# README

* Description
Lineチャットボットアプリケーションのテンプレートとして利用可能なプロジェクト。
下記の機能が実装されています。
また、それぞれの場合に対応するRspecを用いたテストケースを実装しています。
・フォロー・ブロック・ブロック解除に対するアクション
・テキストメッセージへのおうむ返し
・スタンプへの応答
・動画・画像の保存（AWS S3)
そのまま使用する場合、下記のリスクがあります。
リスクを回避するためにはそれぞれ対応するための機能を実装する必要があります。
・過度なメッセージ受信によるAppサーバー負荷の増大
・過度なメッセージ受信・長期的な使用によりDBディスクサイズの増大
・メディアメッセージ受信によるAWS S3ファイルサイズの増大ß

* Ruby version
ruby 2.6.3p62 (2019-04-16 revision 67580) [x86_64-linux]

* System dependencies

* Configuration
Environment variable settings
[Database]
RAILS_MAX_THREADS : 最大同時接続数（参考値：５）
DB_DEV_USER : 開発用DBユーザー名
DB_DEV_PASS : 開発用DBユーザーパスワード
DB_DEV_SCHEMA : 開発用DBスキーマ名
DB_DEV_HOST : 開発用DBホスト名
DB_TEST_SCHEMA : テスト用DBスキーマ名
DB_PRD_SCHEMA : 本番用DBスキーマ名
DB_PRD_USER : 本番用DBユーザー名
DB_PRD_PASS : 本番用DBユーザーパスワード
DB_PRD_HOST : 本番用DBホスト名
DB_PRD_PORT : 本番用DBポート番号
[AWS]
ACCESS_KEY_ID : S3へのアップロード権限を持つAPIアクセス可能なIAMユーザーのアクセスキー
SECRET_ACCESS_KEY : 上記ユーザーのシークレットアクセスキー
[Line Messaging API]
LINE_CHANNEL_ID : LINEチャンネルID
LINE_CHANNEL_SECRET : LINEチャンネルのシークレットID
LINE_CHANNEL_TOKEN : LINEチャンネルのアクセストークン

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

