class PostsController < ApplicationController
  def index
    @products = Post.all
  end
end
