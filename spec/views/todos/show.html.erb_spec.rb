require 'spec_helper'

describe "todos/show" do
  before(:each) do
    @todo = assign(:todo, stub_model(Todo,
      :title => "Title",
      :contents => "MyText",
      :priority => "Priority",
      :status => "Status"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/タイトル/)
    rendered.should match(/内容/)
    rendered.should match(/重要度/)
    rendered.should match(/ステータス/)
  end
end
