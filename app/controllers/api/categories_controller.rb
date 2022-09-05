class Api::CategoriesController < Api::BaseController

    def new
    end

    def create
        return response_failed(:unauthorized, ["You must be logged in to create category"]) unless current_user

        @category = Category.new(category_params)
        # @article.user_id = current_user.id

        if @category.save
        # render json: @article, status: :created, location: @article
            msg = "You have successfully created a new category"
            response_success({ category: serializer_modal(@category, CategorySerializer) }, msg)
        else
            response_failed(:unprocessable_entity, @category.errors.full_messages)
        end            
    end

    def index
      @categories = Category.all
      response_success({ categories: each_serializer_modal(@categories, CategorySerializer) })
    end

    def show
      @category = Category.find_by_id(params[:id])
      if @category
        response_success({ category: serializer_modal(@category, CategorySerializer) })
      else
        response_failed(:not_found, ["Category not found"])
      end
    end


    


    private
    # Only allow a list of trusted parameters through.
    def category_params
      params.require(:category).permit(:name)
    #   params.permit(:name)
      # params.permit(:title, :description, :user_id)
      # params.require(:article).permit(:title, :description)
    end    
end