class ForumThread < ApplicationRecord
    # beauty url
    extend FriendlyId
    friendly_id :title, use: :slugged
    # relasi
    belongs_to :user
    has_many :forum_post, dependent: :destroy

    # validasi
    validates :title, presence: true, length: {maximum:100}
    validates :content, presence: true, length: {minimum:20, maximum:1000}

    # sticky / pinned
    def sticky?
        sticky_order != 100
    end
    
    def pinit!
        self.sticky_order = 1 
        self.save
    end
    
end
