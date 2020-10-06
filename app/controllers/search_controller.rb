class SearchController < ApplicationController
  def search
    params.require([:engine, :text])
    params.permit(:engine, :text)
    engine = params[:engine].downcase
    text = params[:text]

    case engine
    when 'google'
      @message = 'Google search'
    when 'bing'
      @message = 'Bing search'
    # Added 'all' in case more engines are added and 'both' becomes syntactically incorrect
    when 'both', 'all'
      @message = 'Aggregated search'
    else
      raise "Invalid engine"
    end
  end
end
