class PagesController < ApplicationController

  #before_filter :authenticate_user!

	def home
    @blogs = Blog.where(:is_draft => false, :is_archived => false).order("created_at").paginate(:page => params[:page], :per_page => 5)
  end
end
