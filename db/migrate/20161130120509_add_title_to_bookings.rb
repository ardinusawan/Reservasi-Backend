class AddTitleToBookings < ActiveRecord::Migration[5.0]
  def change
    # rails g migration add_title_to_bookings title:string
    add_column :bookings, :title, :string
  end
end
