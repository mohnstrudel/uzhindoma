class AddSlugsToJobtitles < ActiveRecord::Migration
  def change
    add_column :jobtitles, :slug, :string
  end
end
