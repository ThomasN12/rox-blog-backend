# class Api::ArticlesController < ApplicationController
class Api::ArticlesController < Api::BaseController
  before_action :set_article, only: %i[ show update destroy ]
  before_action :is_owner, only: %i[ update destroy ]

  # GET /articles
  def index
    @articles = Article.all
    response_success({ articles: each_serializer_modal(@articles, ArticleSerializer) })
  end

  # GET /article/1
  def show
    if @article
      response_success({ article: serializer_modal(@article, ArticleSerializer) })
    else
      response_failed(:not_found, ["Article not found"])
    end
  end

  # POST /article
  def create
    return response_failed(:unauthorized, ["You must be logged in to update article"]) unless current_user
    @article = Article.new(article_params)
    @article.user_id = current_user.id

    if @article.save
      # render json: @article, status: :created, location: @article
      msg = "You have successfully created a new article"
      response_success({ article: serializer_modal(@article, ArticleSerializer) }, msg)
    else
      response_failed(:bad_request, @article.errors.full_messages)
    end
  end

  # PATCH/PUT /article/1
  def update
    # debugger    
    if @article.update(article_params)
      msg = "You have successfully updated an article"
      response_success(@article, msg)
    else
      response_failed(:bad_request, @article.errors.full_messages)
    end
  end

  # DELETE /article/1
  def destroy
    @article.destroy
    msg = "You have successfully deleted an article"
    response_success(nil, msg)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find_by_id(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      # params.require(:article).permit(:title, :description, :user_id)
      # params.require(:article).permit(:title, :description, category_ids: [])
      # params.require(:article).permit(:title, :description, :category_ids)
      params.permit(:title, :description, category_ids: [])
      # params.permit(:title, :description, :user_id)
      # params.require(:article).permit(:title, :description)
    end

    def is_owner
      return response_failed(:unauthorized, ["You must be logged in to update article"]) unless current_user
      # return response_failed(:unauthorized, ["You are not authorized to edit this article"]) unless current_user.id == @article.user.id
      return response_failed(:unauthorized, ["You are not authorized to edit this article"]) unless current_user == @article.user || current_user.admin
    end
end
