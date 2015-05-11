class AddImageFieldToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs, :image
  end
end
