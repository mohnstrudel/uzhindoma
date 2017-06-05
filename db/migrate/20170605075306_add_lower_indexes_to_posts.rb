class AddLowerIndexesToPosts < ActiveRecord::Migration[5.1]
  def up
    execute %{
      CREATE INDEX
        posts_lower_title
      ON
        posts (lower(title) varchar_pattern_ops)
    }

    execute %{
      CREATE INDEX
        posts_lower_body
      ON
        posts (lower(body) text_pattern_ops)
    }

  end

  def down
    remove_index :posts, name: 'posts_lower_title'
    remove_index :posts, name: 'users_lower_body'
  end
end
