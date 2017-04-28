class Feedback < ApplicationRecord
  
  def self.mean
    ary = all.map{|item| item.rating}
    if ary.length > 0
      mean = ary.sum / ary.length
      return mean
    else
      return 0
    end
  end

end
