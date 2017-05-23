module HistoriesHelper
    attr_accessor :title, :img, :square_img, :event_date
    
    def dummy_history
        @d_datas = dummy_data
    end

    def d_data
        dummy_history[0]
    end
    
    protected
    def dummy_data
        arr = []
        24.times do |i|
            id = i + 1
            title = id%6 == 1 ? "(#{id})" + Faker::Lorem.sentence : nil
            day = i/6 + 1
            date = DateTime.new(2017, 05, day)
            
            if id%6 == 1
                arr << {id: id, title: title, img: "/template/media/gallery/thumbs/#{id}.jpg", square_img: "/template/media/gallery/#{id}.jpg", event_date: date, sub: [] }
            else
                arr.last[:sub] << {id: id, title: title, img: "/template/media/gallery/thumbs/#{id}.jpg", square_img: "/template/media/gallery/#{id}.jpg", event_date: date }
            end
        end
        arr
    end
    
    def title
        d_data[:title]
    end
    
    def img
        d_data[:img]
    end
    
    def square_img
        d_data[:square_img]
    end
    
    def event_date
        d_data[:event_date]
    end
end
