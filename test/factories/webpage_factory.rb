FactoryBot.define do
  factory :webpage do
    user
    url { Faker::Internet.unique.url }
    title { Faker::Lorem.sentence }

    trait :without_title do
      title { }
    end

    trait :unread do
      status { :unread }
    end

    trait :started do
      status { :started }
    end

    trait :read do
      status { :read }
    end

  end
end
