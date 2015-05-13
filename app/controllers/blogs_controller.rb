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
		@categories = Category.all()
	end

	def create
		@blog = current_user.blogs.build(blog_params)

		if @blog.save
			params[:categories].each do |category|
				@blogs_category = BlogsCategory.create({blog_id: @blog.id, category_id: category.to_i})
			end
			redirect_to blogs_path
		else
			redirect_to :back
		end
	end

	def new
		@blog = current_user.blogs.build
		@categories = Category.all()
	end

	def update
		@blog = Blog.find(params[:id])
		
		@blogs_category = BlogsCategory.select("blog_id").where("blog_id = ? AND category_id NOT IN (?)", @blog.id, params[:categories])
		
		if @blog.update(blog_params)
			if params[:categories].present?
  			
  			if @blogs_category.present?
    			@blogs_category.delete_all
  			end

				params[:categories].each do |category|
				  @blogs_category = BlogsCategory.select("blog_id").where("blog_id = ? AND category_id IN (?)", @blog.id, category.to_i)
				  unless @blogs_category.present?
				    @blogs_category = BlogsCategory.create({ blog_id: @blog.id, category_id: category.to_i })
				  end
				end
			else
  			@blogs_category = BlogsCategory.select("blog_id").where("blog_id = ?", @blog.id).delete_all
			end
			redirect_to blogs_path
		end
	end

	private

		def blog_params
			params.require(:blog).permit(:title, :caption, :description, category_id:[])
		end
end
