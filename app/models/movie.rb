class Movie < ActiveRecord::Base
  def self.all_ratings
    return ['G','PG','PG-13','R']
  end
  
  def self.with_ratings(ratings_list)
  # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
  #  movies with those ratings
  # if ratings_list is nil, retrieve ALL movies
    param_list = []
    if ratings_list == nil
      return Movie.all
    end
    if ratings_list.include?('G')
      param_list<<'G'
    end
    if ratings_list.include?('PG')
      param_list<<'PG'
    end
    if ratings_list.include?('PG-13')
      param_list<<'PG-13'
    end
    if ratings_list.include?('R')
      param_list<<'R'
    end
    return Movie.where({rating: param_list})
  end
end
