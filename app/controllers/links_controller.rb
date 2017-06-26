class LinksController < ApplicationController
    before_action :set_link, only: [:show, :edit, :update, :destroy]
    before_action :my_published_fandoms
    
    # GET /links
    # GET /links.json
    def index
        @links = Link.all
    end
    
    # GET /links/1
    # GET /links/1.json
    def show
    end
    
    # GET /links/new
    def new
        @link = Link.new
    end
    
    # GET /links/1/edit
    def edit
    end
    
    # POST /links
    # POST /links.json
    def create
        @link = Link.new(link_params)
        
        respond_to do |format|
            if @link.save
                VisitedLink.find_or_create2(current_user.id, @link.id)
                format.html { redirect_to :back, notice: 'Link was successfully created.' }
                format.json { render :show, status: :created, location: @link }
            else
                format.html { render :new }
                format.json { render json: @link.errors, status: :unprocessable_entity }
            end
        end
    end
    
    # PATCH/PUT /links/1
    # PATCH/PUT /links/1.json
    def update
        respond_to do |format|
            if @link.update(link_params)
                format.html { redirect_to fandom_path(@link.fandom), notice: 'Link was successfully updated.' }
                format.json { render :show, status: :ok, location: @link }
            else
                format.html { render :edit }
                format.json { render json: @link.errors, status: :unprocessable_entity }
            end
        end
    end
    
    # DELETE /links/1
    # DELETE /links/1.json
    def destroy
        @link.destroy
        respond_to do |format|
            format.html { redirect_to :back, notice: 'Link was successfully destroyed.' }
            format.json { head :no_content }
        end
    end
    
    private
    # Use callbacks to share common setup or constraints between actions.
    def set_link
        @link = Link.find(params[:id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def link_params
        params.require(:link).permit(:user_id, :fandom_id, :url, :title, :description, :message, :image, :typee)
    end
end
