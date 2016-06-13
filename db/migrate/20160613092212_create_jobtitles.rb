class CreateJobtitles < ActiveRecord::Migration
  def change
    create_table :jobtitles do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
