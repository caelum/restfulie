class Album < ActiveRecord::Base
  has_many :songs
end

class Song < ActiveRecord::Base
  belongs_to :album
end

3.times do |i|
  album = Album.create!(:title => "Album #{i}", :description => "Description #{i}", :length => i*10)
  4.times do |j|
    album.songs.create!(:title => "Song #{j} from Album #{i}", :description => "Description for song #{j} from Album #{i}", :length => j*10 + i)
  end
end