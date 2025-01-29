class CreateReminders < ActiveRecord::Migration[7.2]
  def change
    create_table :reminders do |t|
      t.string :title
      t.text :description
      t.datetime :trigger_at
      t.decimal :price
      t.string :currency
      t.string :recurrence

      t.timestamps
    end
  end
end
