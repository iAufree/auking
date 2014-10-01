class CommentsController < ApplicationController
  before_filter :authenticate_user!
  before_action :find_comment
  
  def create
    @comment = @topic.comments.build(comment_params.merge(user: current_user))
    if @comment.save
       @comments = @topic.comments.all
       respond_to do |format|
         format.html { redirect_to @topic }
         format.js 
       end
     else
       redirect_to @topic
     end
  end

  def destroy
  	@comment = @topic.comments.find(params[:id])
    if current_user == @comment.user || current_user.admin?
      @comment.destroy
    else
      redirect_to @topic
    end
    if @comment.destroy
      @comment.notifications.destroy
      respond_to do |format|
        @comments = @topic.comments.all
        format.html { redirect_to @topic }
        format.js
      end
    else
      redirect_to @topic
    end
  end

  def edit
  	@comment = Comment.find(params[:id])
  end

  def update
    @comments = @topic.comments.find(params[:id])
    if @comments.update_attributes(comment_params)
      redirect_to @topic
    else
      render 'edit'
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:body)  
    end

    def find_comment
    	@topic = Topic.find(params[:topic_id])
    end
end
