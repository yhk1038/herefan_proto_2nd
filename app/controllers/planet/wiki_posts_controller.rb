class Planet::WikiPostsController < ApplicationController
    include FandomsHelper
    include WikisHelper
    before_action :set_fandom
    before_action :set_wiki_post, only: [:show, :edit, :update, :destroy]
    before_action :inheritance_for_front_view
    before_action :my_published_fandoms
    before_action :set_wiki_pointer_and_ready_layout
    
    # GET /fandoms/:fandom_id/wiki_posts
    # GET /fandoms/:fandom_id/wiki_posts.json
    def index
    end
    
    # GET /fandoms/:fandom_id/wiki_posts/1
    # GET /fandoms/:fandom_id/wiki_posts/1.json
    def show
    end
    
    # GET /fandoms/:fandom_id/wiki_posts/new
    def new
        @wiki_post = WikiPost.new
    end
    
    # GET /fandoms/:fandom_id/wiki_posts/1/edit
    def edit
    end
    
    # POST /fandoms/:fandom_id/wiki_posts
    # POST /fandoms/:fandom_id/wiki_posts.json
    def create
        @wiki_post = WikiPost.new(wiki_post_params)
        
        respond_to do |format|
            if @wiki_post.save
                format.html { redirect_to @wiki_post, notice: 'Wiki post was successfully created.' }
                format.json { render :show, status: :created, location: @wiki_post }
            else
                format.html { render :new }
                format.json { render json: @wiki_post.errors, status: :unprocessable_entity }
            end
        end
    end
    
    # PATCH/PUT /wiki_posts/1
    # PATCH/PUT /wiki_posts/1.json
    def update
        respond_to do |format|
            if @wiki_post.update(wiki_post_params)
                format.html { redirect_to @wiki_post, notice: 'Wiki post was successfully updated.' }
                format.json { render :show, status: :ok, location: @wiki_post }
            else
                format.html { render :edit }
                format.json { render json: @wiki_post.errors, status: :unprocessable_entity }
            end
        end
    end
    
    # DELETE /fandoms/:fandom_id/wiki_posts/1
    # DELETE /fandoms/:fandom_id/wiki_posts/1.json
    def destroy
        @wiki_post.destroy
        respond_to do |format|
            format.html { redirect_to wiki_posts_url, notice: 'Wiki post was successfully destroyed.' }
            format.json { head :no_content }
        end
    end
    
    private
    # Use callbacks to share common setup or constraints between actions.
    def set_wiki_post
        @wiki_post = WikiPost.find(params[:id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def wiki_post_params
        params.require(:wiki_post).permit(:user_id, :wiki_pointer_id, :title, :content, :commit_msg, :row_count, :url)
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
    
    def set_wiki_pointer_and_ready_layout
        @wiki_pointer = WikiPointer.find_by(id: params[:wiki_pointer_id])
        return redirect_to fandom_wikis_path(@fandom) if @wiki_pointer.nil?
        
        @wiki = @wiki_pointer.wiki
        @wiki_posts = @wiki_pointer.wiki_posts
        @sections = @wiki.wiki_pointers
    end
end
