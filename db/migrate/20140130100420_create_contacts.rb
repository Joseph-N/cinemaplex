class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :number
      t.references :cinema, index: true

      t.timestamps
    end
  end
end
