require "./apis/api_base.rb"

class Show < ApiBase
  def initialize(args={})
    super
    @endpoint = "https://api.openai.com/v1/models/#{args[:model]}"
  end

  def call
    super
    puts @data
  end
end

Show.new({model: ARGV[0]}).call

