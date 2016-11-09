class CreateIgrams < ActiveRecord::Migration[5.0]
  def change
    create_table :igrams do |t|
      t.string :url
      t.string :author
      t.string :description
      t.string :thumb_image
      t.string :src_image
      t.integer :comments
      t.integer :likes
      t.string :shortcode

      t.timestamps
    end
  end
end
