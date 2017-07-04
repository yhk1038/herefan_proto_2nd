module WikiPostsHelper
    
    def before_wiki_post
        post = {}
        post[:url] = ''
        post[:msg] = ''
        post[:end] = false
        
        current_index = @wiki_posts.to_a.index @wiki_post
        if current_index.zero?
            post[:end] = true
        end
        
        unless post[:end]
            before_index = current_index - 1
            before_post = @wiki_posts[before_index]
            
            post[:url] = fandom_wiki_post_path(@fandom, before_post, wiki_pointer_id: before_post.wiki_pointer.id)
            post[:msg] = before_post.commit_msg
        end
        
        return post
    end
    
    def next_wiki_post
        post = {}
        post[:url] = ''
        post[:msg] = ''
        post[:end] = false
        
        current_index = @wiki_posts.to_a.index @wiki_post
        if (@wiki_posts.count - 1) == current_index
            post[:end] = true
        end

        unless post[:end]
            next_index = current_index + 1
            next_post = @wiki_posts[next_index]
    
            post[:url] = fandom_wiki_post_path(@fandom, next_post, wiki_pointer_id: next_post.wiki_pointer.id)
            post[:msg] = next_post.commit_msg
        end
        
        return post
    end
end
