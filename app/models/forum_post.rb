class ForumPost < ApplicationRecord
    belongs_to :user
    belongs_to :forum_thread, counter_cache: true
    
    validates :content, presence: true, length: {minimum:5, maximum:500}
end
