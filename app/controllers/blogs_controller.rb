class BlogImageString < StringIO
    attr_accessor :original_filename, :content_type
 end

class BlogsController < ApplicationController
  #before_action :logged_in_user, only: [:create]
  require 'base64'
  before_filter :authenticate_user!, except: [:show]

	def index
		@blogs = current_user.blogs.order("created_at desc").paginate(page: params[:page], per_page: 5)
	end

	def show
		@blog = Blog.find(params[:id])
	end

	def edit
		@blog = Blog.find(params[:id])
	end

	def create
		image = params[:image]
		@blog = current_user.blogs.build(blog_params)

		if @blog.save
			if image.present?
				image64 = image.split(",").second
				io = BlogImageString.new(Base64.decode64(image64))
				io.original_filename = "foobar.png"
				io.content_type = "image/png"
				@blog.image = io
				@blog.save
			end
			redirect_to blogs_path
		end
	end

	def new
		@blog = current_user.blogs.build
	end

	def update
		@blog = Blog.find(params[:id])

		if @blog.update(blog_params)
			redirect_to blogs_path
		else
			render 'edit'
		end
	end


	private

		def blog_params
			params.require(:blog).permit(:title, :caption, :description)
		end
end
