class ProfessionalsController < ApplicationController
  before_action :set_professional, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /professionals or /professionals.json
  def index
    has_permission('professional_index')
    @professionals = Professional.all
  end

  # GET /professionals/1 or /professionals/1.json
  def show
    has_permission('professional_show')
  end

  # GET /professionals/new
  def new
    has_permission('professional_new')
    @professional = Professional.new
  end

  # GET /professionals/1/edit
  def edit
    has_permission('professional_update')
  end

  # POST /professionals or /professionals.json
  def create
    has_permission('professional_new')
    @professional = Professional.new(professional_params)

    respond_to do |format|
      if @professional.save
        format.html { redirect_to @professional, notice: "Profesional creado con éxito." }
        format.json { render :show, status: :created, location: @professional }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @professional.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /professionals/1 or /professionals/1.json
  def update
    has_permission('professional_update')
    respond_to do |format|
      if @professional.update(professional_params)
        format.html { redirect_to @professional, notice: "Profesional actualizado con éxito." }
        format.json { render :show, status: :ok, location: @professional }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @professional.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /professionals/1 or /professionals/1.json
  def destroy
    if has_permission('professional_destroy')
      respond_to do |format|
        if @professional.destroy
          format.html { redirect_to professionals_url, notice: "Profesional eliminado con éxito." }
          format.json { head :no_content }
        else
          format.html { redirect_to professionals_url, alert: "El profesional seleccionado tiene turnos a futuro, por lo que no puede eliminarse" }
          format.json { head :no_content }
        end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_professional
      @professional = Professional.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def professional_params
      params.require(:professional).permit(:name)
    end
end
