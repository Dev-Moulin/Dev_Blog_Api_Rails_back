class Api::V1::ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_article, only: [:show, :update, :destroy]
  before_action :check_article_owner, only: [:update, :destroy]
  before_action :check_article_access, only: [:show]

  def index
    @articles = if user_signed_in?
      Article.where('private IS NULL OR private = ? OR (private = ? AND user_id = ?)', false, true, current_user.id)
    else
      Article.where(private: [false, nil])
    end
    
    render json: {
      status: { code: 200 },
      data: ArticleSerializer.new(@articles).serializable_hash[:data].map { |article| article[:attributes] }
    }
  end

  def show
    render json: {
      status: { code: 200 },
      data: ArticleSerializer.new(@article).serializable_hash[:data][:attributes]
    }
  end

  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      render json: {
        status: { code: 200, message: 'Article créé avec succès.' },
        data: ArticleSerializer.new(@article).serializable_hash[:data][:attributes]
      }, status: :created
    else
      render json: {
        status: { code: 422, message: "Erreur lors de la création de l'article." },
        errors: @article.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def update
    if @article.update(article_params)
      render json: {
        status: { code: 200, message: 'Article mis à jour avec succès.' },
        data: ArticleSerializer.new(@article).serializable_hash[:data][:attributes]
      }
    else
      render json: {
        status: { code: 422, message: "Erreur lors de la mise à jour de l'article." },
        errors: @article.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    render json: {
      status: { code: 200, message: 'Article supprimé avec succès.' }
    }
  end

  private

  def set_article
    @article = Article.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { 
      status: { code: 404, message: "Article non trouvé" }
    }, status: :not_found
  end

  def article_params
    params.require(:article).permit(:title, :content, :private)
  end

  def check_article_owner
    unless @article.user_id == current_user.id
      render json: { error: 'Vous n\'êtes pas autorisé à modifier cet article' }, status: :forbidden
    end
  end

  def check_article_access
    if @article.private? && (!user_signed_in? || @article.user_id != current_user.id)
      render json: { 
        status: { code: 403, message: "Vous n'avez pas accès à cet article privé" }
      }, status: :forbidden
    end
  end
end
