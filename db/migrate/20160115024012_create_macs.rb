class CreateMacs < ActiveRecord::Migration
  def change
    create_table :macs do |t|
      t.text :address

      t.timestamps null: false
    end
  end
end
