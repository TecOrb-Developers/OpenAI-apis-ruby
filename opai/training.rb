require "./config/auth"

class Training
  require "openai"
  require 'json'

  attr_accessor :client

  def initialize
    # @client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
  end

  def call
    # puts client
    # step_one

    data = Auth.new
    p data.api_key
    p data.org
  end

  def step_one
    # prepare_file
    file_id = upload_file
    # file-yUT1FopGuECucIawaWWxpsu2

    if file_id

      fine_tune_job_id = create_finetune_model(file_id)

      # Step 4: Check the status of your fine-tuning job
      status = nil
      @fine_tuned_model = nil
      # thread = Thread.new do
      loop do
        response = client.finetunes.retrieve(id: fine_tune_job_id)

        if response.success?

          status = JSON.parse(response.body)["status"]
          puts "Fine-tuning status: #{status}"

          if status == "succeeded"

            @fine_tuned_model = JSON.parse(response.body)["fine_tuned_model"]
            puts "Fine-tuned model ID: #{@fine_tuned_model}"
            break
          else
            sleep 1
          end
        else
          puts response.parsed_response["error"]["message"]
          puts "Action finished"
          break
        end
      end
      # end

      if @fine_tuned_model
        @fine_tuned_model
      else
        puts "Action finished No fine-tune model received"
      end
    else
      puts "Action finished No file_id received"
    end
  end

  def step_search(fine_tuned_model: "davinci:ft-personal-2023-04-10-11-56-54")
    # fine_tuned_model = "davinci:ft-personal-2023-04-10-11-56-54"
    # "davinci:ft-personal-2023-04-10-11-56-54"
    response = client.completions(parameters: {
      model: fine_tuned_model,
      prompt: "What is your favorite food?"
    })
  end

  def prepare_file
    # Step 1: Prepare dataset file for Fine-Tune
    File.open("../assets/courses.JSONL", "w") do |file|
      file.puts jsonl_file_data
      # jsonl_file_data.each do |obj|
      #   file.puts(JSON.generate(obj))
      # end
    end
  end

  def search_data(prompt, fine_tuned_model)
    # Fine-tuning job has succeeded, get fine-tuned model ID
    # fine_tuned_model = "davinci:ft-personal-2023-04-10-11-56-54"
    # "davinci:ft-personal-2023-04-10-11-56-54"
    # fine_tuned_model = "davinci:ft-personal-2023-04-13-14-25-44"
    # "davinci:ft-personal-2023-04-13-15-28-49"

    # Step 5: Use the fine-tuned model to generate text
    response = client.completions(
      parameters: {
        model: fine_tuned_model,
        prompt: prompt
      }
    )
    if response.success?
      p "Results : => "
      @data = response["choices"].map { |c| c["text"] }
      puts @data

      @data
    else
      puts response.parsed_response["error"]["message"]
    end
  end

  def upload_file
    # Step 2: Upload file to Fine-Tune
    response = client.files.upload(parameters: { file: File.open("../assets/courses.JSONL"), purpose: "fine-tune" })
    
    p "File uploaded response"
    p response

    file_id = JSON.parse(response.body)["id"]
    puts "file_id : #{file_id} ========="
    # file-mEIj30l3W56wbUxZxzDMUH1n
    file_id
  end

  def create_finetune_model(file_id)
    # Step 3: Fine-tune a GPT-3 model
    response = client.finetunes.create(
      parameters: {
        training_file: file_id,
        model: "davinci"
      }
    )

    if response.success?
      fine_tune_job_id = JSON.parse(response.body)["id"]
      puts "Fine-tuning job ID: #{fine_tune_job_id}"
      fine_tune_job_id
    else
      puts response.parsed_response["error"]["message"]
      nil
    end
  end

  private

  def jsonl_file_data
    courses_data.map { |r| JSON.generate(r) }.join("\n")
  end

  def courses_data
    data = []
    Course.all.each do |course|
      if course.name_en.present?
        course_name = "Course ID: #{course.id}\nCourse Name: #{course.name_en}"
        if course.lessons.present?
          course.lessons.each do |lesson|
            if lesson.name_en.present?
              lesson_name = "Lesson Title: #{lesson.name_en}"
              data << { "prompt": "#{course_name}\n#{lesson_name}", "completion": "Course ID: #{course.id}"}
            end
          end
        else
          data << { "prompt": "#{course_name}", "completion": "Course ID: #{course.id}"}
        end
      end
    end
    data
  end
end

# The prompt you pass to get search results depends on the specific task you are trying to accomplish.
# Here are a few examples of prompts you could use with the course dataset you provided:

# 1. To search for courses that are related to Python programming language, you could use a prompt like this: 
# "Find me courses related to Python programming language."

# 2. To search for courses that are tagged with "Ruby" and "Rails", you could use a prompt like this: 
# "Find me courses that are tagged with Ruby and Rails."

# 3. To search for lessons that are related to "indoor games", you could use a prompt like this: 
# "Find me lessons that are related to indoor games."

# 4. To search for courses that have 
# - "Python" and "Programming" in their tags 
# - and also have lessons that are related to "if-else statements",
# you could use a prompt like this: 
# "Find me courses that have Python and Programming in their tags and also have lessons related to if-else statements."

# Note that the prompt you use should be specific to the task you are trying to accomplish and should be designed to elicit the desired search results.


Training.new.call