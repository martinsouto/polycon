class AppointmentsController < ApplicationController
  before_action :set_professional
  before_action :set_appointment, only: %i[ show edit update destroy ]

  # GET /appointments or /appointments.json
  def index
    @appointments = @professional.appointments.all
  end

  # GET /appointments/1 or /appointments/1.json
  def show
  end

  # GET /appointments/new
  def new
    @appointment = @professional.appointments.new
  end

  # GET /appointments/1/edit
  def edit
    if @appointment.date.past?
      flash[:alert] = "No se puede modificar un turno pasado"
      redirect_to professional_appointments_url(@professional)
    end
  end

  # POST /appointments or /appointments.json
  def create
    @appointment = @professional.appointments.new(appointment_params)

    respond_to do |format|
      if @appointment.save
        format.html { redirect_to professional_appointment_path(@professional, @appointment), notice: "Turno creado con éxito." }
        format.json { render :show, status: :created, location: @appointment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /appointments/1 or /appointments/1.json
  def update
    respond_to do |format|
      if @appointment.update(appointment_params)
        format.html { redirect_to professional_appointment_path(@professional, @appointment), notice: "Turno actualizado con éxito." }
        format.json { render :show, status: :ok, location: @appointment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appointments/1 or /appointments/1.json
  def destroy
    respond_to do |format|
      if @appointment.date.future?
        @appointment.destroy
        format.html { redirect_to professional_appointments_url(@professional), notice: "Turno cancelado con éxito." }
        format.json { head :no_content }
      else
        format.html { redirect_to professional_appointments_url(@professional), alert: "No se puede cancelar un turno pasado." }
        format.json { head :no_content }
      end
    end
  end

  private

    def set_professional
      @professional = Professional.find(params[:professional_id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_appointment
      @appointment = @professional.appointments.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def appointment_params
      params.require(:appointment).permit(:date, :first_name, :last_name, :phone, :notes)
    end
end
