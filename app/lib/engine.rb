class Engine
  attr_accessor :config

  def initialize(key)
    raise "Invalid engine" if not Rails.configuration.engines.key? key.to_sym

    @config = Rails.configuration.engines[key.to_sym]
  end

  def search(text)
    puts @config[:path]
  end
end
