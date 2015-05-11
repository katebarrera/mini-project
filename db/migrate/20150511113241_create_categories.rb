class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :id
      t.string :name

      t.timestamps null: false
    end
  end
end
