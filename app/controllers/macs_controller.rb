class MacsController < ApplicationController
  before_action :set_mac, only: [:show, :edit, :update, :destroy]

  # GET /macs
  # GET /macs.json
  def index
    @macs = Mac.all
  end

  # GET /macs/1
  # GET /macs/1.json
  def show
  end

  # GET /macs/new
  def new
    @mac = Mac.new
  end

  # GET /macs/1/edit
  def edit
  end

  # POST /macs
  # POST /macs.json
  def create
    @mac = Mac.new(mac_params)

    respond_to do |format|
      if @mac.save
        format.html { redirect_to @mac, notice: 'Mac was successfully created.' }
        format.json { render :show, status: :created, location: @mac }
      else
        format.html { render :new }
        format.json { render json: @mac.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /macs/1
  # PATCH/PUT /macs/1.json
  def update
    respond_to do |format|
      if @mac.update(mac_params)
        format.html { redirect_to @mac, notice: 'Mac was successfully updated.' }
        format.json { render :show, status: :ok, location: @mac }
      else
        format.html { render :edit }
        format.json { render json: @mac.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /macs/1
  # DELETE /macs/1.json
  def destroy
    @mac.destroy
    respond_to do |format|
      format.html { redirect_to macs_url, notice: 'Mac was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mac
      @mac = Mac.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mac_params
      params.require(:mac).permit(:address)
    end
end
