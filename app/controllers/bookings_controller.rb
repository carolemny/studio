class BookingsController < ApplicationController
  before_action :set_booking, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  before_action :is_guest?, only: [:show, :edit, :destroy, :update]

  def index
    @bookings = Booking.all
  end

  def show
  end

  def new
    @booking = Booking.new
  end

  def edit
  end

  def create
    @booking = Booking.new(booking_params)

    respond_to do |format|
      if @booking.save
        format.html { redirect_to @booking, notice: "La réservation a bien été créée." }
        format.json { render :show, status: :created, location: @booking }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
    UserMailer.booking_email(current_user.id).deliver_now
  end

  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to @booking, notice: "La réservation a bien été mise à jour." }
        format.json { render :show, status: :ok, location: @booking }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @booking.destroy
    respond_to do |format|
      format.html { redirect_to bookings_url, notice: "La réservation a bien été annulée. " }
      format.json { head :no_content }
    end
  end

  private
    
    def set_booking
      @booking = Booking.find(params[:id])
    end

    def booking_params
      params.fetch(:booking, {})
    end

    def is_guest?
      @booking = set_booking
      unless @booking.guest_id == current_user.id
        flash[:danger] = "Vous n'êtes pas autorisé à modifier cette réservation."
        redirect_to root_path
      end
    end
end
