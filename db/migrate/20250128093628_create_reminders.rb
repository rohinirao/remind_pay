class CreateReminders < ActiveRecord::Migration[7.2]
  def change
    create_table :reminders do |t|
      t.string :title, null: false
      t.text :description
      t.datetime :trigger_at, null: false
      t.decimal :price, null: false
      t.string :currency, null: false
      t.string :recurrence, null: false

      t.timestamps
    end
  end
end
