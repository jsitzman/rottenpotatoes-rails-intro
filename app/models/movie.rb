class Movie < ActiveRecord::Base
  def self.all_ratings
    rating_array = Array.new
    self.select("rating").uniq.each {|item| rating_array.push(item.rating)}
    rating_array.sort.uniq
  end
end
