class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :order_no
      t.integer :amount
      t.string :channel
      t.string :currency
      t.string :client_ip
      t.string :app_key
      t.string :status
      t.integer :paid_at
      t.timestamps
    end
  end
end
