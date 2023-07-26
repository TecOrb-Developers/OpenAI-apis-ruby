require "./apis/api_base.rb"

class Show < ApiBase
  def initialize(args={})
    super
    @endpoint = "https://api.openai.com/v1/fine-tunes/#{args[:fine_tune_id]}"
  end

  def call
    super
    puts @data
  end
end

Show.new({fine_tune_id: ARGV[0]}).call