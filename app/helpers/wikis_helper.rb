module WikisHelper
    
    def dummy_wiki_append
        wiki = Wiki.create(fandom: @fandom, name: @fandom.name)
        @fandom.wikis << wiki
        
        wikis = 6.times{|i| Wiki.create(fandom: @fandom, wiki: wiki, name: "member #{i+1}") }
        @fandom.wikis << wikis
    end
end
