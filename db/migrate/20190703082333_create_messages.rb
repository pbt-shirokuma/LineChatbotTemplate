class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.string :message_id
      t.text :request
      t.string :request_status
      t.text :responcse
      t.string :responce_status
      t.timestamps
    end
  end
end
