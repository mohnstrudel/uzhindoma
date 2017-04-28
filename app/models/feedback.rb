class Feedback < ApplicationRecord
  
  def self.mean
    ary = all.map{|item| item.rating}
    mean = ary.sum / ary.length
    return mean
  end

end
