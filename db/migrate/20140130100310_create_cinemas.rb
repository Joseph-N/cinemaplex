class CreateCinemas < ActiveRecord::Migration
  def change
    create_table :cinemas do |t|
      t.string :name
      t.references :movie, index: true

      t.timestamps
    end
  end
end
