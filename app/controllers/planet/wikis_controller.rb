class Planet::WikisController < ApplicationController
    include FandomsHelper
    before_action :set_fandom
    before_action :set_wiki, only: [:show, :edit, :update, :destroy]
    before_action :inheritance_for_front_view
    before_action :my_published_fandoms
    
    # GET /fandoms/:fandom_id/wikis
    # GET /fandoms/:fandom_id/wikis.json
    def index
        @wikis = Wiki.where(fandom_id: params[:fandom_id])
        @wiki   = @wikis.find_by(wiki: nil)
        @sub_wikis = @wiki.wikis
    end
    
    # GET /fandoms/:fandom_id/wikis/1
    # GET /fandoms/:fandom_id/wikis/1.json
    def show
    end
    
    # GET /fandoms/:fandom_id/wikis/new
    def new
        @wiki = Wiki.new
    end
    
    # GET /fandoms/:fandom_id/wikis/1/edit
    def edit
    end
    
    # POST /fandoms/:fandom_id/wikis
    # POST /fandoms/:fandom_id/wikis.json
    def create
        @wiki = Wiki.new(wiki_params)
        
        respond_to do |format|
            if @wiki.save
                format.html { redirect_to @wiki, notice: 'Wiki was successfully created.' }
                format.json { render :show, status: :created, location: @wiki }
            else
                format.html { render :new }
                format.json { render json: @wiki.errors, status: :unprocessable_entity }
            end
        end
    end
    
    # PATCH/PUT /fandoms/:fandom_id/wikis/1
    # PATCH/PUT /fandoms/:fandom_id/wikis/1.json
    def update
        respond_to do |format|
            if @wiki.update(wiki_params)
                format.html { redirect_to @wiki, notice: 'Wiki was successfully updated.' }
                format.json { render :show, status: :ok, location: @wiki }
            else
                format.html { render :edit }
                format.json { render json: @wiki.errors, status: :unprocessable_entity }
            end
        end
    end
    
    # DELETE /fandoms/:fandom_id/wikis/1
    # DELETE /fandoms/:fandom_id/wikis/1.json
    def destroy
        @wiki.destroy
        respond_to do |format|
            format.html { redirect_to wikis_url, notice: 'Wiki was successfully destroyed.' }
            format.json { head :no_content }
        end
    end
    
    private
    # Use callbacks to share common setup or constraints between actions.
    def set_wiki
        @wiki = Wiki.find(params[:id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def wiki_params
        params.require(:wiki).permit(:fandom_id, :wiki_id, :name)
    end

    def inheritance_for_front_view
        set_for_fandom_show_template_data
        @tabs[0][:active] = 'active'
    
        if user_signed_in?
            @follow_control[:follow_cmd]    = is_my_fandom?(user: current_user, fandom: @fandom) ? 'cancel' : 'follow'
            @follow_control[:myfandom_id]   = @my_fandom.take.nil? ? 0 : @my_fandom.take.id
            @follow_control[:channel_id]    = @fandom.id
            @follow_control[:user_id]       = current_user.id
        end
    end
end
