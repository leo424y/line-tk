class CreateLikes < ActiveRecord::Migration[6.0]
  def change
    create_table :likes do |t|
      t.integer :link_id
      t.string :mail
      t.string :note

      t.timestamps
    end

    add_index :likes, :mail
  end
end
