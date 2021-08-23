class AddIndexToLinks < ActiveRecord::Migration[6.0]
  def change
    add_index :links, :url
    add_index :links, :note
  end
end
