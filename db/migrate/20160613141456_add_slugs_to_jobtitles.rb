class AddSlugsToJobtitles < ActiveRecord::Migration[4.2]
  def change
    add_column :jobtitles, :slug, :string
  end
end
