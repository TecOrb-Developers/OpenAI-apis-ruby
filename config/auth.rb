class Auth
  require 'dotenv'
  Dotenv.load

  attr_accessor :org, :api_key

  def initialize
    @org = ENV["OPENAI_ORG_ID"]
    @api_key = ENV["OPENAI_API_KEY"]
  end
end