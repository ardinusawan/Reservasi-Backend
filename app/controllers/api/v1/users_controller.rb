module Api::V1
  class UsersController < ApplicationController
    before_filter :authenticate_request!
    before_filter :authenticate_request!, only: [:update, :destroy]
    before_action :set_user, only: [:show, :update, :destroy]

    # GET /users
    def index
      @users = User.all

      render json: @users.as_json(:except => [:password])
    end

    # GET /users/1
    def show
      render json: @user.as_json(:except => [:password])
    end

    # GET /users/nrp_nip/:nrp_nip
    def find_by_nrp_nip
      @user = User.find_by(nrp_nip: params[:nrp_nip])
      if @user.nil?
        @message = Array.new
        @message.push("Message" => "User Not Found")
        render json: @message
      else
        render json: @user.as_json(:except => [:password])
      end
    end

    # POST /users
    def create
      @user = User.new(user_params)

      if @user.save
        render json: @user.as_json(:except => [:password]), status: :created, location: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /users/1
    def update
      if @user.update(user_params)
        render json: @user.as_json(:except => [:password])
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    # DELETE /users/1
    def destroy
      @user.destroy
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def user_params
        params.require(:user).permit(:name, :email, :hp, :nrp_nip, :password, :is_admin)
      end
  end
end
