require "./config/auth"

class ApiBase  
  require 'active_support'
  require 'active_support/core_ext'
  require 'httparty'


  def initialize(args={})
    auth = Auth.new
    @headers =  {
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{auth.api_key}",
      "OpenAI-Organization" => auth.org
    }
    @endpoint = ""
    @args = args
  end

  def call
    response = HTTParty.get(@endpoint, :headers => @headers)
    @data = JSON.parse response.body
  end

  
end