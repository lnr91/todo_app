# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    nick_name "MyString"
    email "MyString"
    password_digest "MyString"
  end
end
