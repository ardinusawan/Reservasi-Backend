class HomeController < ApplicationController
  #before_filter :authenticate_request!

  def index
    #render json: {'logged_in' => true}
    render :file => 'public/index.html'
  end
end
