class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
  	@user = User.find_by_name(params[:id])
  	@topics = @user.topics.last(10).reverse
  	@comments = @user.comments.last(10).reverse
  end
end
