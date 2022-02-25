class MailsController < ApplicationController
  def index
    @mail = session[:mail]
    @links = Link.find(Like.where(mail: session[:mail]).pluck(:link_id)).reverse
  end
end
