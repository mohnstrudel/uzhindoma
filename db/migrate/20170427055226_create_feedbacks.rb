class CreateFeedbacks < ActiveRecord::Migration[5.0]
  def change
    create_table :feedbacks do |t|
      t.float :rating
      t.string :name
      t.string :email
      t.string :body

      t.timestamps
    end
  end
end
