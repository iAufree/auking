class AttachmentsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @attachment = current_user.attachments.create params.require(:attachment).permit(:file)
    render json: { url: @attachment.file.url }
  end
end
