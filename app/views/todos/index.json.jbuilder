json.array!(@todos) do |todo|
  json.extract! todo, :id, :title, :contents, :due, :priority, :status
  json.url todo_url(todo, format: :json)
end
