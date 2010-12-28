# Introspective methods to assist in the conversion of collections in other formats.
class Array

  # Return max update date for items in collection, for it uses the updated_at of items.
  # 
  #==Example:
  #
  # Find max updated at in ActiveRecord objects 
  #
  #   albums = Albums.find(:all)
  #   albums.updated_at
  # 
  # Using a custom field to check the max date
  #
  #   albums = Albums.find(:all)
  #   albums.updated_at(:created_at)
  #
  def updated_at(field = :updated_at)
    max = max_by{|o| o.send(field)}
    if max
      max.send(field)
    else
      Time.now
    end
  end

  def published_at(field = :published_at)
    min = min_by{|o| o.send(field)}
    if min
      min.send(field)
    else
      Time.now
    end
  end
end