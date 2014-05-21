class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.string :title
      t.text :contents
      t.date :due
      t.string :priority
      t.string :status

      t.timestamps
    end
  end
end
