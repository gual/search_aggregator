require 'net/https'
require 'uri'

class Engine
  attr_accessor :config

  def initialize(key)
    raise 'Invalid engine' if not Rails.configuration.engines.key? key.to_sym

    @config = Rails.configuration.engines[key.to_sym]
  end

  def search(text)
    params = @config[:'query-parameters'] || Hash.new
    params[@config[:'search-parameter']] = text

    headers = @config[:headers] || Hash.new

    uri = URI(@config[:path])
    uri.query = URI.encode_www_form(params)
    request = Net::HTTP::Get.new(uri)
    headers.each {|k, v| request[k] = v}

    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(request)
    end
  end
end
