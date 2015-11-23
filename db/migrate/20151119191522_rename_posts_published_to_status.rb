class RenamePostsPublishedToStatus < ActiveRecord::Migration
  def change
    rename_column :posts, :published, :status
  end
end
