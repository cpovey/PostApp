FactoryGirl.define do
  factory :comment do
    content {["Etiam eros lacus, bibendum pulvinar dolor in, tristique dapibus erat.",
              "Integer lectus nulla, accumsan vitae malesuada quis, ultrices ac nisl.",
              "Sed efficitur augue nibh, a bibendum arcu tempus sed. Nullam.", 
              "Nulla tempor est ex, vitae tempus justo facilisis tincidunt. Mauris.", 
              "Interdum et malesuada fames ac ante ipsum primis in faucibus."].sample}
    post { FactoryGirl.create(:post) }
    user { FactoryGirl.create([:craig, :will, :kumi].sample) }
    # comments build_list(:comment)
  end
end