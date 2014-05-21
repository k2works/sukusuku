# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :todo do
    title "MyString"
    contents "MyText"
    due "2014-05-18"
    priority "MyString"
    status "MyString"
  end
end
