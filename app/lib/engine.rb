require 'net/https'
require 'uri'
require 'json'

class Engine
  attr_accessor :config, :key

  def initialize(key)
    if (key == 'both' || key == 'all')
      @key = 'all'
    elsif Rails.configuration.engines.key? key.to_sym
      @key = key
      @config = Rails.configuration.engines[key.to_sym]
    else
      raise 'Invalid engine'
    end
  end

  def search(text)
    if @key == 'all'
      all_results = Array.new
      Rails.configuration.engines.keys.each do |engine_key|
        engine = Engine.new(engine_key)
        engine.search(text).each {|engine_result| all_results.push(engine_result)}
      end

      urls_found = Hash.new
      all_results.each do |res|
        if urls_found.has_key? res[:url]
          urls_found[res[:url]] = urls_found[res[:url]] + 1
          res[:counter] = urls_found[res[:url]]
        else
          urls_found[res[:url]] = 1
          res[:counter] = 1
        end
      end

      all_results
    else
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
      format_result(response.body)
    end
  end

  def format_result(resp_body)
    props = [:title, :url, :snippet]
    body = JSON(resp_body)
    items = body
    result_config = @config[:results]

    items_path = result_config[:path].split('.')
    items_path.each {|ip| items = items[ip]}

    result = Array.new
    items.each do |item|
      item_hash = Hash.new
      props.each {|prop| item_hash[prop] = item[result_config[prop]]}
      item_hash[:engine] = @key
      result.push(item_hash)
    end
    result
  end
end
