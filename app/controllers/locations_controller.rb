class LocationsController < ApplicationController
  include Requested
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  @@geocodejob = GeocodeJob
  def LocationsController::geocodejob=(klass)
    @@geocodejob = klass
  end
  def LocationsController::geocodejob
    @@geocodejob
  end

  # GET /locations/current
  # GET /locations/current.json
  def current
    @location = Location.where(host: src_addr_on_header).order(updated_at: :desc).first
    if not @location or @location.expired?
      @location = Location.new(host: src_addr_on_header)
      @location.save! # assign an id to be presneted to the front end
      @@geocodejob.perform_later(id: @location.id)
    end
    render :host, layout: false
  end

  # GET /locations/server
  # GET /locations/server.json
  def server
    @location = Location.where(host: host_on_header).order(updated_at: :desc).first
    if not @location	# Server location does not expire
      @location = Location.new(host: host_on_header)
      @location.save! # assign an id to be presneted to the front end
      @@geocodejob.perform_later(id: @location.id)
    end
    render :host, layout: false
  end

  # GET /locations
  # GET /locations.json
  def index
    @locations = Location.all
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
  end

  # GET /locations/new
  def new
    @location = Location.new
    @location.host = src_addr_on_header
  end

  # GET /locations/1/edit
  def edit
  end

  # POST /locations
  # POST /locations.json
  def create
    @@geocodejob.perform_later(location_params)

    respond_to do |format|
      format.html { redirect_to locations_url, notice: 'Location was enqued.' }
      format.json { render :show, status: :ok } # FIXME
    end
  end

  # PATCH/PUT /locations/1
  # PATCH/PUT /locations/1.json
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location.destroy
    respond_to do |format|
      format.html { redirect_to locations_url, notice: 'Location was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      params.require(:location).permit(:host, :latitude, :longitude, :city)
    end
end
