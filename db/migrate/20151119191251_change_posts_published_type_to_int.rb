class ChangePostsPublishedTypeToInt < ActiveRecord::Migration
  def change
    change_column :posts, :published, :integer, default: 0
  end
end
