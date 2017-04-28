class AddLowerIndexesToOrders < ActiveRecord::Migration[5.0]
  def up
    execute %{
      CREATE INDEX
        orders_lower_second_name
      ON
        orders (lower(second_name) varchar_pattern_ops)
    }

    execute %{
      CREATE INDEX
        orders_lower_first_name
      ON
        orders (lower(first_name) varchar_pattern_ops)
    }

    execute %{
      CREATE INDEX
        orders_lower_phone
      ON
        orders (lower(phone) varchar_pattern_ops)
    }
  end

  def down
    remove_index :orders, name: 'orders_lower_second_name'
    remove_index :orders, name: 'orders_lower_first_name'
    remove_index :orders, name: 'orders_lower_phone'
  end
end
