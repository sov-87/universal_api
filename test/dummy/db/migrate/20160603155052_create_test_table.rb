class CreateTestTable < ActiveRecord::Migration
  def change
    create_table :test_table do |t|
      t.string :name, null: false
    end
  end
end
