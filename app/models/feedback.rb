class Feedback < ApplicationRecord

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, :body, :rating, presence: true
  validates :email, presence: true, 
                format: { with: VALID_EMAIL_REGEX }
  
  def self.mean
    ary = all.map{|item| item.rating}
    ary = ary.compact
    if ary.length > 0
      mean = ary.sum / ary.length
      return mean
    else
      return 0
    end
  end

end
