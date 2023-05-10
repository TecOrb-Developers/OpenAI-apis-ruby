require "./apis/api_base.rb"

class List < ApiBase
  def initialize
    super
    @endpoint = "https://api.openai.com/v1/fine-tunes"
  end

  def call
    super
    if @data["object"] == "list" && @data["data"].present?
      @data["data"].each do |ele|
        puts ele["id"]
      end
    else
      puts []
    end
  end

end

List.new.call