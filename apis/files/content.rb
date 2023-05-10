require "./apis/api_base.rb"

class Content < ApiBase
  def initialize(args={})
    super
    @endpoint = "https://api.openai.com/v1/files/#{args[:file_id]}/content"
  end

  def call
    super
    puts @data
  end
end

Content.new({file_id: ARGV[0]}).call