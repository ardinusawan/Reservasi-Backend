class SchedulesController < ApplicationController
  before_action :set_schedule, only: [:show, :update, :destroy]

  # GET /now
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

  # GET /day/2011-11-10
  def day
    date = params[:date].split(',')
    booking_list = Array.new
    schedule = Schedule.all
    schedule.each do |booking|
      if booking.start.strftime("%Y-%m-%d") == date[0].to_s
        @bookings_now = Schedule.find(booking.id)
        booking_list.push(@bookings_now)
      else
        response = false
      end
    end
    if response == false
      render json: false
    else render json: booking_list
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
    #to = data[:end].to_datetime
    tmp = from - 7.hours

    if data[:repeated]!="0"
      if data[:repeated]=="1" #loop each day
        $i = 0
        while $i < data[:repeated_end_after].to_i
        #while tmp <= to
          data_insert = {
              "booking_id" => data[:booking_id],
              "start" => tmp,
              "end" => tmp + hours + minute + second
          }
          tmp += data[:repeated_every].to_i.day
          @schedule = Schedule.new(data_insert)

          if @schedule.save
             response = true
          else
            response = false
            errors = @schedule.errors
          end
          $i +=1
        end
      elsif data["repeated"]=="2" #loop each week
        $i = 0
        while $i < data[:repeated_end_after].to_i
        # while tmp <= to
          data_insert = {
              "booking_id" => data["booking_id"],
              "start" => tmp,
              "end" => tmp + hours + minute + second
          }
          tmp += data[:repeated_every].to_i.week

          @schedule = Schedule.new(data_insert)
          if @schedule.save
            response = true
          else
            response = false
            errors = @schedule.errors
          end
          $i +=1
        end
      elsif data["repeated"]=="3" #loop each month
        $i = 0
        while $i < data[:repeated_end_after].to_i
        # while tmp <= to
          data_insert = {
              "booking_id" => data["booking_id"],
              "start" => tmp,
              "end" => tmp + hours + minute + second
          }
          tmp += data[:repeated_every].to_i.month
          @schedule = Schedule.new(data_insert)
          if @schedule.save
            response = true
          else
            response = false
            errors = @schedule.errors
          end
          $i +=1
        end
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
      render json: @schedule, status: :created, location: @schedule
    else
      #@schedule = false
      if errors.nil?
        errors = {
            "message" => "Cannot create interval data"
        }
      end
      render json: errors, status: :unprocessable_entity
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
