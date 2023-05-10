require "./apis/api_base.rb"

class List < ApiBase
  def initialize
    super
    @endpoint = "https://api.openai.com/v1/models"
  end

  def call
    super
    if @data["object"] == "list" && @data["data"].present?
      @data["data"].each do |model|
        puts model["id"]
      end
    end
  end

end

List.new.call