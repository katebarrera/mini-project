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
		@categories = Category.all
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
			params[:categories].each do |category|
				@blog_category = BlogsCategory.create({blog_id: @blog.id, category_id: category.to_i})
			end
			redirect_to blogs_path
		else
			redirect_to :back
		end
	end

	def new
		@blog = current_user.blogs.build
		@categories = Category.all
	end

	def update
		image = params[:image]
		@blog = Blog.find(params[:id])
		
		@blogs_categories = BlogsCategory.select("blog_id").where("blog_id = ? AND category_id NOT IN (?)", @blog.id, params[:categories])
		
		if @blog.update(blog_params)
			if params[:image].present?
				image64 = image.split(",").second
				io = BlogImageString.new(Base64.decode64(image64))
				io.original_filename = "foobar.png"
				io.content_type = "image/png"
				@blog.image = io
				@blog.update(blog_params)
			end

			if params[:categories].present?
  			
  			if @blogs_categories.present?
    			@blogs_categories.delete_all
  			end

				params[:categories].each do |category|
				  @blog_category = BlogsCategory.select("blog_id").where("blog_id = ? AND category_id IN (?)", @blog.id, category.to_i)
				  unless @blog_category.present?
				    @blog_category = BlogsCategory.create({ blog_id: @blog.id, category_id: category.to_i })
				  end
				end
			else
  			@blogs_categories = BlogsCategory.select("blog_id").where("blog_id = ?", @blog.id).delete_all
			end
			redirect_to blogs_path
		end
	end

	private

		def blog_params
			params.require(:blog).permit(:title, :caption, :description, category_id:[])
		end
end
