class Blog < ActiveRecord::Base
	belogs_to :user
end
