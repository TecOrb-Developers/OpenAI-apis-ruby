require "./apis/api_base.rb"

class Upload < ApiBase
  def initialize(args={})
    super
    @endpoint = "https://api.openai.com/v1/files"

    # Get the current directory of this script
    current_dir = File.dirname(__FILE__)
    jsonl_file_path = File.join(current_dir, "../../assets/courses.JSONL")

    @body = { 
      "file" => File.open("../../assets/courses.JSONL"),
      "purpose" => "fine-tune"
    }
  end

  def call
    response = HTTParty.post(@endpoint, :headers => @headers, :body => @body)
    @data = JSON.parse response.body
    puts @data
  end
end

Upload.new.call