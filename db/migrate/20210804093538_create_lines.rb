class CreateLines < ActiveRecord::Migration[6.0]
  def change
    create_table :lines do |t|
      t.string :note
      t.string :url

      t.timestamps
    end
  end
end
