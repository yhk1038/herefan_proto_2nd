class Wiki < ApplicationRecord
    belongs_to :fandom
    belongs_to :wiki
    has_many :wikis
    has_many :wiki_pointers, dependent: :destroy
    has_many :wiki_infos, dependent: :destroy
    
    after_create :set_default_infos
    
    def infos
        infos = self.wiki_infos
        infos = self.set_default_infos if infos.count.zero?
        
        return infos
    end
    
    
    # private (public 함수로 두되, private 처럼 사용해야 함. 일단 이렇게 두고 나중에 바꾸자.)
    def set_default_infos
        wiki = self
        
        labels = %w(agency distributor debut fandom)
        labels.each do |label|
            wiki_info = WikiInfo.create do |info|
                info.wiki = wiki
                info.title = label
                info.content = '<em>Blanks yet.. Please fill it!<em>'
            end
            wiki.wiki_infos << wiki_info
        end
        
        return wiki.wiki_infos
    end
end
