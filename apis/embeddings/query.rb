require "./apis/api_base.rb"
require "./lib/cosine.rb"

class Query < ApiBase

  def initialize(args={})
    super
    @endpoint = "https://api.openai.com/v1/embeddings"
    @query = "food for good sleeping"
  end

  def call
    query_vector = query_embedding

   # The next step is to loop through all rows of the CSV file, 
   # and compare the question vector to the original text vectors. 
   # The cosine_similarity method will compare the question against each 
   # of the original texts and will return a number between 0 and 1.

   # You are interested in the similarity with the highest value. 
   # This is the text with the closest meaning and intent to the question.

    # Store the similairty scores as the code loops through the CSV
    similarity_array = []

    # Loop through the CSV and calculate the cosine-similarity between
    # the question vector and each text embedding

    current_dir = File.dirname(__FILE__)
    embeddings_file_path = File.join(current_dir, "../../assets/embeddings.csv")
    CSV.foreach(embeddings_file_path, headers: true) do |row|
      # Extract the embedding from the column and parse it back into an Array
      text_embedding =  JSON.parse(row['embedding'])

      # Add the similarity score to the array
      similarity_array << cosine_similarity(query_vector, text_embedding)
    end

    # Return the index of the highest similarity score
    index_of_max = similarity_array.index(similarity_array.max)
    # puts similarity_array
    puts index_of_max
    # The index_of_max variable now contains the index of the highest similarity score.
    # This can be used to extract the text from the CSV that is needed to send to 
    # GPT-3 along with the users question.

    # Used to store the original text
    original_text = ""

    # Loop through the CSV and find the text which matches the highest
    # similarity score
    CSV.foreach(embeddings_file_path, headers: true).with_index do |row, rowno|
      if rowno == index_of_max
        original_text = row['text']
      end
    end

    puts original_text
  end

  private

  def query_embedding
    # Get embedding for asked query
    puts "Query: #{@query}"
    @body = {
      "input": @query,
      "model": "text-embedding-ada-002"
    }
    response = HTTParty.post(@endpoint, :headers => @headers, :body => @body.to_json)
    @data = JSON.parse response.body

    embedding = @data['data'][0]['embedding']
  end

  def cosine_similarity vec_a, vec_b
    Cosine.new(vec_a, vec_b).calculate_similarity
  end
end

Query.new({query: ARGV[0]}).call
