class PlaylistsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @playlists = Playlist.all
    @eco_scores = Playlist.find_by(name: "eco_score")
    @nutri_scores = Playlist.find_by(name: "nutri_score")
    @prices = Playlist.find_by(name: "price_score")

    @nutri_products = Product.joins(:category, :comments)
  end
end
