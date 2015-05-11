class BlogsController < ApplicationController

	def index
		@blog = Blog.all
	end

	def show
		@blog = Blog.find(params[:id])
	end

	def edit
	end

	def create
		@blog = Blog.new(blog_params)

		if @blog.save
			flash[:success] = "Blog created!"
			redirect_to blogs_path
		else
			render 'pages/home'
		end
	end

	def new
		@blog = current_user.blogs.build
	end

	private

		def blog_params
			params.require(:blog).permit(:title, :caption, :description)
		end
end
