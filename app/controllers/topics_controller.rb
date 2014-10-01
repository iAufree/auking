class TopicsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :destroy_suggest_topics, only: [:index]

  def index
    @suggest_topics = Topic.suggest.all
    @topics = Topic.paginate(page: params[:page], per_page: 15).unsuggest.all.order("updated_at desc")
  end

  def new
    @topic = current_user.topics.new
  end

  def show
    @topics = Topic.all
    @topic = Topic.find(params[:id])
    @comments = @topic.comments.paginate(page: params[:page], per_page: 30)
    @likeable = Likeship.likeable(@topic)
  end

  def create
    @topic = current_user.topics.build(topic_params)
    if @topic.save
      flash[:success] = "发帖成功!"
      respond_to do |format|
        format.html { redirect_to @topic }
        format.js 
      end
    else
      render 'new'
    end
  end
  
  def edit
    @topic = current_user.topics.find(params[:id])
  end

  def update
    @topic = current_user.topics.find(params[:id])
    if @topic.update_attributes(topic_params)
      respond_to do |format|
        format.html { redirect_to @topic }
        format.js 
      end
    else 
      render 'edit'
    end
  end
  
  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy
    respond_to do |format|
      format.js { redirect_via_turbolinks_to topics_path }
      format.html { redirect_to topics_path }
    end
  end

  private
    def topic_params
      params.require(:topic).permit(:title, :content)
    end

  def destroy_suggest_topics
    @suggest_topics = Topic.suggest.all
    if @suggest_topics.count > 3
      @suggest_topics.order('updated_at desc').last.update_attributes(suggested: false)
    end
  end
end
