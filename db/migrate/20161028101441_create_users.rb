class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      # t.string :email
      t.string :hp
      t.string :nrp_nip
      t.string :password
      t.boolean :is_admin

      t.timestamps
    end
  end
end
