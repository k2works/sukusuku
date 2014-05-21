require 'spec_helper'

describe Todo do
  describe '.create' do
    it 'ステータスのデフォルト値は 0' do
      todo = Todo.create
      expect(todo.status).to eq 0
    end
  end
end
