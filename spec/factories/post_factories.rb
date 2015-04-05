FactoryGirl.define do
  factory :post do
    title "Really Cool Post"
    content "This is my first post, I hope you all like it!"
    user { FactoryGirl.create(:craig) }

    factory :another_post do
      title "Will's First Post"
      content "This is Will's first post, isn't it great?!"
      user { FactoryGirl.create(:will) }
    end
  end
end