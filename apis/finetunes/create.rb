# file-qqUMd8qgnaOr2BFuZFhL84gl
require "./apis/api_base.rb"

class Create < ApiBase
  def initialize(args={})
    super
    @endpoint = "https://api.openai.com/v1/fine-tunes"

    @body = { 
      "training_file": args[:file_id],
      "model": "davinci"
    }
  end

  def call
    response = HTTParty.post(@endpoint, :headers => @headers, :body => @body.to_json)
    @data = JSON.parse response.body
    # {"object"=>"fine-tune", "id"=>"ft-diDG5OH9haqCmmKEtxt2nyWT", "hyperparams"=>{"n_epochs"=>4, "batch_size"=>nil, "prompt_loss_weight"=>0.01, "learning_rate_multiplier"=>nil}, "organization_id"=>"org-8xpEMKNp1qvrPfFR2ntcOZxb", "model"=>"davinci", "training_files"=>[{"object"=>"file", "id"=>"file-qqUMd8qgnaOr2BFuZFhL84gl", "purpose"=>"fine-tune", "filename"=>"courses.JSONL", "bytes"=>32707, "created_at"=>1690192514, "status"=>"processed", "status_details"=>nil}], "validation_files"=>[], "result_files"=>[], "created_at"=>1690194666, "updated_at"=>1690194666, "status"=>"pending", "fine_tuned_model"=>nil, "events"=>[{"object"=>"fine-tune-event", "level"=>"info", "message"=>"Created fine-tune: ft-diDG5OH9haqCmmKEtxt2nyWT", "created_at"=>1690194666}]}
    puts @data
  end
end

Create.new({file_id: ARGV[0]}).call
# Create.new({file_id: "file-qqUMd8qgnaOr2BFuZFhL84gl"}).call
