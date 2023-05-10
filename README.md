## OpenAI-apis-ruby
OpenAI APIs implementations via ruby

### ENV variables configurations

Add `.env` file in root directory on the project with your Open AI keys

```
OPENAI_ORG_ID=org-1abcsdxxxx
OPENAI_API_KEY=sk-94j3udoxxxx
```

Blow are the rake tasks added to run the APIs
Task | Description |
--- | --- |
rake files:list| # Files list |
rake files:show[file_id]    |       # File details
rake finetunes:list         |       # Fine-tune list
rake finetunes:show[fine_tune_id] |  # Fine-tune details
rake models:list            |       # Models list
rake models:show[model_id]  |       # Model details

For calling rake tasks with arguments you can run:

`rake models:show'[mymodelid]'`

For multiple arguments:

`rake task_namespace:task_name'[arg1 arg2]'`