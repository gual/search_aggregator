class SearchController < ApplicationController
  def search
    params.require([:engine, :text])
    params.permit(:engine, :text)
    engine_key = params[:engine].downcase
    text = params[:text]

    engine = Engine.new(engine_key)
    engine.search(text)
  end
end
