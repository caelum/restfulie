ActionController::Routing::Routes.draw do |map|
  map.resources :albums do |album|
    album.resources :songs, :controller => 'albums/songs'
    album.resources :artists, :controller => 'albums/artists'
  end
  map.resources :songs
end