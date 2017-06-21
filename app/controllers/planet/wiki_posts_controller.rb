class Planet::WikiPostsController < ApplicationController
    include FandomsHelper
    include WikisHelper
    before_action :set_fandom
    before_action :set_wiki_post, only: [:show, :edit, :update, :destroy]
    before_action :inheritance_for_front_view, except: [:create]
    before_action :my_published_fandoms
    before_action :set_wiki_pointer_and_ready_layout, except: [:create, :new]
    before_action :check_login
    
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
        @wiki_pointer = WikiPointer.new(wiki_id: params[:wiki_id], sort_num: params[:sort_num])
        return redirect_to fandom_wikis_path(@fandom) if @wiki_pointer.nil?
    
        @wiki = @wiki_pointer.wiki
        @wiki_posts = @wiki_pointer.wiki_posts
        @sections = @wiki.wiki_pointers
        @wiki_post = WikiPost.new
    end
    
    # GET /fandoms/:fandom_id/wiki_posts/1/edit
    def edit
    end
    
    # POST /fandoms/:fandom_id/wiki_posts
    # POST /fandoms/:fandom_id/wiki_posts.json
    # already have [
    #   @fandom                     (:set_fandom),
    #   @my_published_fandoms       (:my_published_fandoms)
    # ]
    def create
        create_method = set_wiki_pointer_and_ready_create
        # already have [
        #   @fandom                     assoc   'current fandom instance'                                       (:set_fandom),
        #   @my_published_fandoms       assoc   'my followed fandoms instances'                                 (:my_published_fandoms),
        #   @wiki_pointer               inst    'find_or_create_by(id: params[:wiki_post][:wiki_pointer_id])'   (:set_wiki_pointer_and_ready_create, saved(:complete_new_wiki_pointer) or find(this)),
        #   @wiki                       inst    '@wiki_pointer.wiki'                                            (:set_wiki_pointer_and_ready_create),
        #   @wiki_posts                 assoc   '@wiki_pointer.wiki_posts'                                      (:set_wiki_pointer_and_ready_create),
        #   @sections                   assoc   '@wiki.wiki_pointers'                                           (:set_wiki_pointer_and_ready_create)
        # ]
        
        @wiki_post = WikiPost.new(wiki_post_params)
        
        respond_to do |format|
            insert_post_to_correct_pointer if create_method == 'new'
            if @wiki_post.save
                redirect_path = fandom_wikis_url(@fandom)
                redirect_path += '?w=' + @wiki_post.wiki_id.to_s if @wiki_post.wiki_id
                update_pointer_sorting_label
                format.html { redirect_to redirect_path, notice: 'Wiki post was successfully created.' }
                format.json { render :show, status: :created, location: @wiki_post }
            else
                format.html { redirect_to :back }
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
    def check_login
        redirect_to fandom_wikis_path(@fandom) unless user_signed_in?
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_wiki_post
        @wiki_post = WikiPost.find(params[:id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def wiki_post_params
        params.require(:wiki_post).permit(:user_id, :wiki_pointer_id, :title, :content, :commit_msg, :row_count, :url, :wiki_id)
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
    
    
    
    
    
    
    
    
    
    ###
    #   [1]
    #
    # Call at :create
    # already have [
    #   @fandom                     (:set_fandom),
    #   @my_published_fandoms       (:my_published_fandoms)
    # ]
    def set_wiki_pointer_and_ready_create
        @wiki_pointer = WikiPointer.find_or_create_by(id: params[:wiki_post][:wiki_pointer_id])
        
        if @wiki_pointer.wiki_id.nil?
            continuable = complete_new_wiki_pointer(params[:wiki_post][:wiki_id])
            create_method = 'new'
        else
            continuable = true
            create_method = 'edit'
        end
        # already have [
        #   @fandom                     (:set_fandom),
        #   @my_published_fandoms       (:my_published_fandoms)
        #   @wiki_pointer               ( saved(:complete_new_wiki_pointer) or find(this) )
        # ]
    
        if continuable
            @wiki = @wiki_pointer.wiki
            @wiki_posts = @wiki_pointer.wiki_posts
            @sections = @wiki.wiki_pointers
            
            return create_method
        else
            return redirect_to :back
        end
    end
    
    ###
    #   [2]
    #
    def complete_new_wiki_pointer(wiki_id)
        @wiki_pointer.wiki_id = wiki_id
        @wiki_pointer.sort_num = params[:wiki_post][:row_count]
        @wiki_pointer.save
    end
    
    def insert_post_to_correct_pointer
        @wiki_pointer.wiki_posts << @wiki_post
    end
    
    def update_pointer_sorting_label
        @wiki_pointer.update(sort_num: @wiki_post.row_count)
        
        pointers = @wiki_pointer.wiki.wiki_pointers.order(sort_num: :asc).all
        
        arr = pointers.to_a
        arr.delete_at(arr.index(@wiki_pointer))
        arr.insert(@wiki_pointer.sort_num - 1, @wiki_pointer)
        arr.each do |wp|
            num = arr.index(wp) + 1
            wp.update(sort_num: num)
        end
    end
end
