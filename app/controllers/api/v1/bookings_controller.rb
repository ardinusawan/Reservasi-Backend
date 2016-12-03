module Api::V1
  class BookingsController < ApplicationController
    before_filter :authenticate_request!, only: [:update, :destroy]
    before_action :set_booking, only: [:show, :update, :destroy]

    # GET /bookings/unapproved
    def unapproved
      need_approve = Array.new
      Booking.find_each do |booking|
        if booking.validation_by == 0
          need_approve.push(booking)
        end
      end
      if need_approve.nil?
        head :no_content
      else
        render json: need_approve
      end
    end

    # GET /bookings/approved
    def approved
      approved = Array.new
      Booking.find_each do |booking|
        if booking.validation_by!=0
            approved.push(booking)
        end
      end
      if approved.nil?
        head :no_content
      else
        render json: approved
      end
    end

    # POST /approving
    def approving
      if @booking.update(booking_params)
        render json: @booking
      else
        render json: @booking.errors, status: :unprocessable_entity
      end
    end

    # GET /bookings
    def index
      @bookings = Booking.all

      render json: @bookings
    end

    # GET /bookings/1
    def show
      render json: @booking
    end

    # POST /bookings
    def create
      @booking = Booking.new(booking_params)

      if @booking.save
        render json: @booking, status: :created, location: @booking
      else
        render json: @booking.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /bookings/1
    def update
      if @booking.update(booking_params)
        render json: @booking
      else
        render json: @booking.errors, status: :unprocessable_entity
      end
    end

    # DELETE /bookings/1
    def destroy
      @booking.destroy
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_booking
        @booking = Booking.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def booking_params
        params.require(:booking).permit(:user_id, :title, :validation_by, :type_id, :description)
      end
  end
end