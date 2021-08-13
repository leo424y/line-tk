class AddIndexToLines < ActiveRecord::Migration[6.0]
  def change
    add_index :lines, :url
    add_index :lines, :note
  end
end
