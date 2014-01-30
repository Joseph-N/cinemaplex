class CreateShowTimes < ActiveRecord::Migration
  def change
    create_table :show_times do |t|
      t.time :hour
      t.references :cinema, index: true

      t.timestamps
    end
  end
end
