class SiteMastersController < ApplicationController
  before_action :set_site_master, only: [:show, :edit, :update, :destroy]

  # GET /site_masters
  # GET /site_masters.json
  def index
    @site_masters = SiteMaster.all
  end

  # GET /site_masters/1
  # GET /site_masters/1.json
  def show
  end

  # GET /site_masters/new
  def new
    @site_master = SiteMaster.new
  end

  # GET /site_masters/1/edit
  def edit
  end

  # POST /site_masters
  # POST /site_masters.json
  def create
    @site_master = SiteMaster.new(site_master_params)

    respond_to do |format|
      if @site_master.save
        format.html { redirect_to @site_master, notice: 'Site master was successfully created.' }
        format.json { render :show, status: :created, location: @site_master }
      else
        format.html { render :new }
        format.json { render json: @site_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /site_masters/1
  # PATCH/PUT /site_masters/1.json
  def update
    respond_to do |format|
      if @site_master.update(site_master_params)
        format.html { redirect_to @site_master, notice: 'Site master was successfully updated.' }
        format.json { render :show, status: :ok, location: @site_master }
      else
        format.html { render :edit }
        format.json { render json: @site_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /site_masters/1
  # DELETE /site_masters/1.json
  def destroy
    @site_master.destroy
    respond_to do |format|
      format.html { redirect_to site_masters_url, notice: 'Site master was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_site_master
      @site_master = SiteMaster.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def site_master_params
      params.require(:site_master).permit(:message_login_please, :message_global_error, :fandom_publish_count)
    end
end
