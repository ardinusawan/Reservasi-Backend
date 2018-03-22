# Created By:
# I Dewa Putu Ardi Nusawan

module Api::V1
  class SchedulesController < ApplicationController
    respond_to :json
    before_action :authenticate_request!, only: [:update, :destroy]
    before_action :set_schedule, only: [:show, :update, :destroy]

    def conflict?(date1, date2)
      # https://stackoverflow.com/a/325964/4154982
      return ((date1.first <= date2.last) && (date1.last >= date2.first))
    end

    # POST /schedules/conflict
    def conflict
      schedules = Schedule.where("start >= ?", Time.zone.now.beginning_of_day)
      schedules_conflict_list = Array.new
      from = params[:start].to_datetime
      to = params[:start].to_datetime + params[:duration].to_i.seconds
      from = from.in_time_zone
      to = to.in_time_zone
      from = from - 7.hours
      to = to - 7.hours
      if params[:repeated]=="0"
        tmp_from = from
        tmp_to = to
        $i = 0
        schedules.each_with_index do |schedule, index|
            if (conflict?([tmp_from, tmp_to],
                          [schedule.start.to_datetime, schedule.end.to_datetime])) and $i < 1
              @schedule_conflict = Schedule.find(schedule.id)
              schedules_conflict_list.push($i => Array(@schedule_conflict))
              $i +=1
            end
        end
      else
        tmp_from = from
        tmp_to = to
        $i = 0
        while $i < params[:repeated_end_after].to_i            
          schedules.each_with_index do |schedule, index|
            if conflict?([tmp_from, tmp_to], [schedule.start, schedule.end])
              @schedule_conflict = Schedule.find(schedule.id )
              schedules_conflict_list.push(Array(@schedule_conflict))
            end
          end

          tmp_from += (params[:repeated_every].to_i.day if params[:repeated]=="1") || 
                      (params[:repeated_every].to_i.week if params[:repeated]=="2") || 
                      (params[:repeated_every].to_i.month if params[:repeated]=="3")
          
          tmp_to += (params[:repeated_every].to_i.day if params[:repeated]=="1") || 
                    (params[:repeated_every].to_i.week if params[:repeated]=="2") || 
                    (params[:repeated_every].to_i.month if params[:repeated]=="3")
      
          $i+=1
        end
      end
      if schedules_conflict_list.none?
        render :json => { :success => true}
       else
         render :json => { :success => false,
                           :conflict => schedules_conflict_list }
      end
    end

    # GET /schedules/now
    def now
      schedule = Schedule.all
      schedule.each do |booking|
        if booking.start < DateTime.now and booking.end > DateTime.now
          @bookings_now = Schedule.find(booking.id)
          render json: @bookings_now
        else
          response = false
        end
      end
      if response == false
        render json: false
      end
    end

    # GET /schedules/2011-11-10
    def date
      date = params[:date].split(',')
      booking_list = Array.new
      schedule = Schedule.all
      schedule.each do |schedules|
        booking = Booking.find(schedules.booking_id)
        if schedules.start.strftime("%Y-%m-%d") == date[0].to_s and booking.validation_by!=0
          @bookings_now = Schedule.find(schedules.id)
          booking_list.push(@bookings_now)
        else
          response = false
        end
      end
      if response == false
        render json: false
      else
        render json: booking_list.sort_by { |hash| hash['start'].to_i }
      end

    end

    # GET /schedules
    def index
      @schedules = Schedule.all

      render json: @schedules
    end

    # GET /schedules/1
    def show
      render json: @schedule
    end

    # POST /schedules
    def create
      conflict  = Array.new
      from = Time.parse(params[:start])
      schedules = Schedule.where("start >= ?", Time.zone.now.beginning_of_day)
      for i in (1..params[:repeated_end_after].to_i)
        to = from + params[:duration].to_i.seconds

        schedules.each do |schedule|
          if conflict?([from, to], [schedule.start.to_datetime, schedule.end.to_datetime])
            conflict.push(Schedule.find(schedule.id))
          end

        end

        data_insert = {
            booking_id: params[:booking_id],
            start: from,
            end: to
        }

        if conflict.empty?
          @schedule = Schedule.new(data_insert)
          unless @schedule.save
            render json: {success: false, error: @schedule.error}, status: :unprocessable_entity
          end
        end

        if params[:repeated]=="1"
          from += params[:repeated_every].to_i.day
        elsif params[:repeated]=="2"
          from += params[:repeated_every].to_i.week
        elsif params[:repeated]=="3"
          from += params[:repeated_every].to_i.month
        else
          from = from
        end
      end

      if conflict.empty?
        render json: {success: true, data: @schedule}, status: :created
      else
        render json: {success: false, conflict: conflict}, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /schedules/1
    def update
      if @schedule.update(schedule_params)
        render json: @schedule
      else
        render json: @schedule.errors, status: :unprocessable_entity
      end
    end

    # DELETE /schedules/1
    def destroy
      @schedule.destroy
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_schedule
        @schedule = Schedule.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def schedule_params
        params.require(:schedule).permit(:booking_id, :start, :end)
      end
  end
end
