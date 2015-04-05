FactoryGirl.define do
  factory :user do
    name  "Mr. Foo"
    city "San Francisco"

    factory :craig do
      name "Craig"
    end

    factory :will do
      name "Will"
    end

    factory :kumi do 
      name "Kumi"
    end
  end
end