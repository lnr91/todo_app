FactoryGirl.define do
  factory :user do
    sequence(:nick_name) {|n| "nick_name#{n}"}
    sequence(:email) {|n| "nick_name#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"
  end

  factory :list do
    sequence(:name) {|n| "List Item #{n}"}
    sequence(:description) {|n| "List Description #{n}"}
    user
  end

  factory :task do
    sequence(:description) {|n| "Task Description #{n}"}
    completed false
    list
  end

end
