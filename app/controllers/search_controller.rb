class SearchController < ApplicationController
  def search
    params.require([:engine, :text])
    params.permit(:engine, :text)
    engine = params[:engine]
    text = params[:text]
    @message = 'Search result'
  end
end
