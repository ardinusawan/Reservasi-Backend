# Created By:
# I Dewa Putu Ardi Nusawan

module Api::V1
  class TypesController < ApplicationController
    respond_to :json

    before_action :authenticate_request!, only: [:update, :destroy]
    before_action :set_type, only: [:show, :update, :destroy]

    # GET /types
    def index
      @types = Type.all

      render json: @types
    end

    # GET /types/1
    def show
      render json: @type
    end

    # POST /types
    def create
      @type = Type.new(type_params)

      if @type.save
      respond_with :api, :v1, json: @type, status: :created
      else
        respond_with :api, :v1, json: @type.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /types/1
    def update
      if @type.update(type_params)
        render json: @type
      else
        render json: @type.errors, status: :unprocessable_entity
      end
    end

    # DELETE /types/1
    def destroy
      @type.destroy
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_type
        @type = Type.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def type_params
        params.require(:type).permit(:name)
      end
  end
end