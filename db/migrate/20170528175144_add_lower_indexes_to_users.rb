class AddLowerIndexesToUsers < ActiveRecord::Migration[5.0]
  def up
    execute %{
      CREATE INDEX
        users_lower_second_name
      ON
        users (lower(second_name) varchar_pattern_ops)
    }

    execute %{
      CREATE INDEX
        users_lower_first_name
      ON
        users (lower(first_name) varchar_pattern_ops)
    }

    execute %{
      CREATE INDEX
        users_lower_phone
      ON
        users (lower(phone) varchar_pattern_ops)
    }

    execute %{
      CREATE INDEX
        users_lower_email
      ON
        users (lower(email) varchar_pattern_ops)
    }
  end

  def down
    remove_index :users, name: 'users_lower_second_name'
    remove_index :users, name: 'users_lower_first_name'
    remove_index :users, name: 'users_lower_phone'
    remove_index :users, name: 'users_lower_email'
  end
end
