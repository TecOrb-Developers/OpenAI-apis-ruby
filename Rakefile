namespace :openai do
  desc "Load and start OpenAI training module"
  task :training do
    ruby './opai/training.rb'
  end
end

namespace :models do
  desc "Models list"
  # rake models:list
  task :list do
    ruby "./apis/models/list.rb"
  end

  desc "Model details"
  # rake models:show'[text-similarity-babbage-001]'
  task :show, [:model_id] do |t, args|
    ruby "./apis/models/show.rb #{args[:model_id]}" 
  end
end

namespace :files do
  desc "Files list"
  # rake files:list
  task :list do
    ruby "./apis/files/list.rb"
  end

  desc "File details"
  # rake files:show'[text-similarity-babbage-001]'
  task :show, [:file_id] do |t, args|
    ruby "./apis/files/show.rb #{args[:file_id]}" 
  end
end

namespace :finetunes do
  desc "Fine-tune list"
  # rake finetunes:list
  task :list do
    ruby "./apis/finetunes/list.rb"
  end

  desc "Fine-tune details"
  # rake finetunes:show'[text-similarity-babbage-001]'
  task :show, [:fine_tune_id] do |t, args|
    ruby "./apis/finetunes/show.rb #{args[:fine_tune_id]}" 
  end
end

