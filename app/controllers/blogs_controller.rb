class BlogsController < ApplicationController
  #before_action :logged_in_user, only: [:create]
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
		@blog = current_user.blogs.build(blog_params)

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
			params.require(:blog).permit(:title, :caption, :description, :image)
		end
end
