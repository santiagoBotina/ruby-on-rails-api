class PostsController < ApplicationController
  #throw an error whenever our api fails
  rescue_from Exception do |e|
    render json: { error: e.message }, status: :internal_error
  end
  
  #throw errors when a method with "!" is present
  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { error: e.message }, status: :unprocessable_entity
  end

  #For all published records
  def index
    @post = Post.where(published: true)
    render json: @post, status: :ok
  end

  #Referenced to one record ex: GET /post/{id}
  def show
    @post = Post.find(params[:id])
    render json: @post, status: :ok
  end

  def create
    @post = Post.create!(create_params)
    render json: @post, status: :created
  end

  def update
    @post = Post.find(params[:id])
    @post.update!(update_params)
    render json: @post, status: :ok
  end

  private

  def create_params
    params.require(:post).permit(:title, :content, :published, :user_id)
  end

  def update_params
    params.require(:post).permit(:title, :content, :published)
  end
end
