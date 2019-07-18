class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      
      t.string :name , null: false
      t.string :line_id , null: false
      t.string :status , null: false
      t.boolean :del_flg , default: false
      t.timestamps
      
    end
  end
end
