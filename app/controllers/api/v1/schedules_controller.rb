# Jakarta -> +7 GMT
# So, i decided to decrement all date with minus 7 hours
# Ardi Nusawan
module Api::V1
  class SchedulesController < ApplicationController
    respond_to :json
    before_filter :authenticate_request!, only: [:update, :destroy]
    before_action :set_schedule, only: [:show, :update, :destroy]

    def conflict?(date1, date2)
      (date1.last <= date2.first && date1.first >= date2.last)
    end

    # POST /schedules/conflict
    def conflict
      error = false
      schedules = Schedule.all
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
      elsif params[:repeated]=="1"
        tmp_from = from
        tmp_to = to
        $i = 0
          schedules.each_with_index do |schedule, index|
              if (conflict?([tmp_from, tmp_to],
                            [schedule.start.to_datetime, schedule.end.to_datetime])) and $i < params[:repeated_end_after].to_i
              @schedule_conflict = Schedule.find(schedule.id )
              schedules_conflict_list.push($i => Array(@schedule_conflict))
              tmp_from += params[:repeated_every].to_i.day
              tmp_to += params[:repeated_every].to_i.day
              $i +=1
              end
          end
      elsif params[:repeated]=="2"
        tmp_from = from
        tmp_to = to
        $i = 0
        schedules.each_with_index do |schedule, index|
            if (conflict?([tmp_from, tmp_to],
                          [schedule.start.to_datetime, schedule.end.to_datetime])) and $i < params[:repeated_end_after].to_i
              @schedule_conflict = Schedule.find(schedule.id )
              schedules_conflict_list.push($i => Array(@schedule_conflict))
              tmp_from += params[:repeated_every].to_i.week
              tmp_to += params[:repeated_every].to_i.week
              $i +=1
            end
        end
      elsif params[:repeated]=="3"
        tmp_from = from
        tmp_to = to
        $i = 0
        schedules.each_with_index do |schedule, index|
            if (conflict?([tmp_from, tmp_to],
                          [schedule.start.to_datetime, schedule.end.to_datetime])) and $i < params[:repeated_end_after].to_i
              @schedule_conflict = Schedule.find(schedule.id )
              schedules_conflict_list.push($i => Array(@schedule_conflict))
              tmp_from += params[:repeated_every].to_i.month
              tmp_to += params[:repeated_every].to_i.month
              $i +=1
            end
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
      data = params
      hours =  Time.at(data[:duration].to_i).strftime("%H")
      hours = hours.to_i.hours - 7.hours
      minute =  Time.at(data[:duration].to_i).strftime("%M")
      minute = minute.to_i.minutes
      second =  Time.at(data[:duration].to_i).strftime("%S")
      second = second.to_i.seconds
      from = data[:start].to_datetime
      tmp = from - 7.hours

      if data[:repeated]!="0"
          $i = 0
          while $i < data[:repeated_end_after].to_i
            data_insert = {
                "booking_id" => data[:booking_id],
                "start" => tmp,
                "end" => tmp + hours + minute + second
            }
            if data[:repeated]=="1"
              tmp += data[:repeated_every].to_i.day
            elsif data["repeated"]=="2"
              tmp += data[:repeated_every].to_i.week
            elsif data["repeated"]=="3"          
              tmp += data[:repeated_every].to_i.month
            end
            @schedule = Schedule.new(data_insert)

            if @schedule.save
               response = true
            else
              response = false
              errors = @schedule.errors
            end
            $i +=1
          end
      elsif data["repeated"]=="0"
        data_insert = {
            "booking_id" => data[:booking_id],
            "start" => tmp,
            "end" => tmp + hours + minute + second
        }
        @schedule = Schedule.new(data_insert)

        if @schedule.save
          response = true
        else
          response = false
          errors = @schedule.errors
        end
      end

      if response==true
        render json: @schedule, status: :created
      else
        if errors.nil?
          errors = {
              "message" => "Cannot create interval data"
          }
        end
        respond_with :api, :v1, json: errors, status: :unprocessable_entity
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
