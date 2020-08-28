class PlaylistsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @playlists = Playlist.all
  end

end
