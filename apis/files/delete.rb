require "./apis/api_base.rb"

class Delete < ApiBase
  def initialize(args={})
    super
    @endpoint = "https://api.openai.com/v1/files/#{args[:file_id]}"
  end

  def call
    response = HTTParty.delete(@endpoint, :headers => @headers)
    @data = JSON.parse response.body
    puts @data
  end
end

Delete.new({file_id: ARGV[0]}).call