FactoryGirl.define do
  factory :image do
    url { ["http://i.imgur.com/fSgnUKW.jpg", "http://i.imgur.com/zV4Gfr3.jpg", "http://i.imgur.com/CsoTpRK.jpg", "http://i.imgur.com/nruy8eg.jpg"].sample }
    post
  end
end