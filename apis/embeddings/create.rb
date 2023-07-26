require "./apis/api_base.rb"

class Create < ApiBase
  def initialize(args={})
    super
    @endpoint = "https://api.openai.com/v1/embeddings"
  end

  def call

    puts courses_in_text_data
    # @body = {
    #   "input": "plant based food",
    #   "model": "text-embedding-ada-002"
    # }
    # response = HTTParty.post(@endpoint, :headers => @headers, :body => @body.to_json)
    # @data = JSON.parse response.body
    # puts @data
  end

  private
  def courses_in_text_data
    embedding_array = []

    current_dir = File.dirname(__FILE__)
    json_file_path = File.join(current_dir, "../../assets/courses_for_embedding.json")

    json_file = File.open(json_file_path)
    json_data =  JSON.load json_file
    json_data["courses"].each do |course|
      # Prepare data
      course_data = "Id: #{course['id']}\nTitle: #{course['title']}"
      if course["lessons"].present?
        course_data += "\nLessons:"
        course["lessons"].each do |lesson|
          course_data += "\n#{lesson["title"]}"
        end
      end
      puts course_data

      # Get embedding
      @body = {
        "input": course_data,
        "model": "text-embedding-ada-002"
      }
      response = HTTParty.post(@endpoint, :headers => @headers, :body => @body.to_json)
      @data = JSON.parse response.body
      puts @data
      embedding = @data['data'][0]['embedding']

      # Map embedding with data
      embedding_hash = {embedding: embedding, text: course_data}
      embedding_array << embedding_hash
    end

    # Update embeddings CSV
    CSV.open(File.join(current_dir, "../../assets/embeddings.csv"), "w") do |csv|
      csv << [:embedding, :text]
      embedding_array.each do |obj|
        csv << [obj[:embedding], obj[:text]]
      end
    end
  end
end

Create.new.call
