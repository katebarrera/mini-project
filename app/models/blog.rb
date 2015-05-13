class Blog < ActiveRecord::Base
	belongs_to :user
  mount_uploader :image, BlogsImageUploader
end
