FactoryBot.define do
  factory :tag do
    factory :valid_tag do
      sequence(:name) do
        n = ''
        loop do
          n = "Tag #{rand(1000)}"
          break unless Tag.where(name: n).exists?
        end
        n
      end
    end
  end
end
