class CreateUserTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :user_tokens do |t|
      t.bigint :user_id, comment: "ユーザーID"
      t.string :token, null: false, comment: "ログイン用のトークン"
      t.datetime :expired_at, null: false, comment: "有効期限"
      t.string :device_name, comment: "デバイス名"
      t.timestamps comment: "作成日, 更新日"
    end
    add_foreign_key :user_tokens, :users
  end
end

