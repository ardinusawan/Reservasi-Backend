class CreateBookings < ActiveRecord::Migration[5.0]
  def change
    create_table :bookings do |t|
      t.references :user, foreign_key: true
      t.integer :validation_by
      t.references :type, foreign_key: true
      t.string :description

      t.timestamps
    end
  end
end
