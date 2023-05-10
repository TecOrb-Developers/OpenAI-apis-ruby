require "./apis/api_base.rb"

class Show < ApiBase
  def initialize(args={})
    super
    @endpoint = "https://api.openai.com/v1/files/#{args[:file_id]}"
  end

  def call
    super
    puts @data
  end
end

Show.new({file_id: ARGV[0]}).call