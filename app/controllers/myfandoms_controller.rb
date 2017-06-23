class MyfandomsController < ApplicationController
    before_action :set_myfandom, only: [:show, :edit, :update, :destroy]
    
    # GET /myfandoms
    # GET /myfandoms.json
    def index
        @myfandoms = Myfandom.all
    end
    
    # GET /myfandoms/1
    # GET /myfandoms/1.json
    def show
    end
    
    # GET /myfandoms/new
    def new
        @myfandom = Myfandom.new
    end
    
    # GET /myfandoms/1/edit
    def edit
    end
    
    # POST /myfandoms
    # POST /myfandoms.json
    def create
        @myfandom = Myfandom.new(myfandom_params)
        
        respond_to do |format|
            if @myfandom.save
                fandom = @myfandom.fandom
                if fandom.myfandoms.count >= config_update_publish_limit
                    fandom.update(published: true, published_updated_at: DateTime.now)
                end
                format.html { redirect_to @myfandom, notice: 'Myfandom was successfully created.' }
                format.json { render json: @myfandom } # :show, status: :created, location: @myfandom
            else
                format.html { render :new }
                format.json { render json: @myfandom.errors, status: :unprocessable_entity }
            end
        end
    end
    
    # PATCH/PUT /myfandoms/1
    # PATCH/PUT /myfandoms/1.json
    def update
        respond_to do |format|
            if @myfandom.update(myfandom_params)
                format.html { redirect_to @myfandom, notice: 'Myfandom was successfully updated.' }
                format.json { render :show, status: :ok, location: @myfandom }
            else
                format.html { render :edit }
                format.json { render json: @myfandom.errors, status: :unprocessable_entity }
            end
        end
    end
    
    # DELETE /myfandoms/1
    # DELETE /myfandoms/1.json
    def destroy
        @myfandom.destroy
        fandom = @myfandom.fandom
        if fandom.myfandoms.count < config_update_publish_limit
            fandom.update(published: false, published_updated_at: DateTime.now)
        end
        respond_to do |format|
            format.html { redirect_to myfandoms_url, notice: 'Myfandom was successfully destroyed.' }
            format.json { head :no_content }
        end
    end
    
    private
    # Use callbacks to share common setup or constraints between actions.
    def set_myfandom
        @myfandom = Myfandom.find(params[:id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def myfandom_params
        params.require(:myfandom).permit(:fandom_id, :user_id)
    end
end
