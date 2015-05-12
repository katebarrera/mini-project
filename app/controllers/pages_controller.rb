class PagesController < ApplicationController

	def home
    if user_signed_in?
      redirect_to blogs_path
    else
      @blogs = Blog.where(:is_draft => false, :is_archived => false).order("created_at desc").paginate(:page => params[:page], :per_page => 5)
   end
  end
end
