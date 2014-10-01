class WelcomeController < ApplicationController
  def index
  	@topics = Topic.excellent
  end
end
