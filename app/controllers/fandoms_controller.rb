class FandomsController < ApplicationController
    before_action :set_fandom, only: [:show, :edit, :update, :destroy]
    before_action :filling_tab_group, only: [:show]
    
    # GET /fandoms
    # GET /fandoms.json
    def index
        @fandoms = Fandom.all.sort_by { |fandom| 0 - fandom.myfandoms.count }
    end
    
    # GET /fandoms/1
    # GET /fandoms/1.json
    def show
        @links = @fandom.links
    end
    
    # GET /fandoms/new
    def new
        @fandom = Fandom.new
    end
    
    # GET /fandoms/1/edit
    def edit
    end
    
    # POST /fandoms
    # POST /fandoms.json
    def create
        @fandom = Fandom.new(fandom_params)
        
        respond_to do |format|
            if @fandom.save
                format.html { redirect_to @fandom, notice: 'Fandom was successfully created.' }
                format.json { render :show, status: :created, location: @fandom }
            else
                format.html { render :new }
                format.json { render json: @fandom.errors, status: :unprocessable_entity }
            end
        end
    end
    
    # PATCH/PUT /fandoms/1
    # PATCH/PUT /fandoms/1.json
    def update
        respond_to do |format|
            if @fandom.update(fandom_params)
                format.html { redirect_to @fandom, notice: 'Fandom was successfully updated.' }
                format.json { render :show, status: :ok, location: @fandom }
            else
                format.html { render :edit }
                format.json { render json: @fandom.errors, status: :unprocessable_entity }
            end
        end
    end
    
    # DELETE /fandoms/1
    # DELETE /fandoms/1.json
    def destroy
        @fandom.destroy
        respond_to do |format|
            format.html { redirect_to fandoms_url, notice: 'Fandom was successfully destroyed.' }
            format.json { head :no_content }
        end
    end
    
    private
    # Use callbacks to share common setup or constraints between actions.
    def set_fandom
        @fandom = Fandom.find(params[:id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def fandom_params
        params.require(:fandom).permit(:name, :profile_img, :background_img)
    end

    def filling_tab_group
        @tabs = []
        @tabs << { name: 'wiki', path: '', active: '' }
        @tabs << { name: 'history', path: '', active: '' }
        @tabs << { name: 'library', path: '', active: 'active' }
        @tabs << { name: 'schedule', path: '', active: '' }
    end
end
