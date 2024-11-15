FactoryBot.define do
  factory :contributor_profile do
    factory :valid_contributor_profile do
      sequence(:name) do
        n = ''
        loop do
          n = "Contributor #{rand(1000)}"
          break unless ContributorProfile.where(name: n).exists?
        end
        n
      end

      factory :published_contributor_profile do
        publish { true }
      end

      factory :unpublished_contributor_profile do
        publish { false }
      end
    end
  end
end
