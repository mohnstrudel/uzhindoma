class CreateJobtitles < ActiveRecord::Migration[4.2]
  def change
    create_table :jobtitles do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
