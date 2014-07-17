FactoryGirl.define do
  factory :dragoon do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email_address) { |n| "tester#{n}@example.com" }
    password "12345678"
    password_confirmation "12345678"

    factory :registered_user do
      sequence(:name) { |n| "Registered User #{n}" }
      role "registered"
    end

    factory :administrator do
      sequence(:name) { |n| "Administrator #{n}" }
      role "administrator"
    end
  end
end
