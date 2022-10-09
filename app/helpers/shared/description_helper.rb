module Shared::DescriptionHelper
  def descriptions_are_identical?(describables)
    identical_describables =
      describables.select do |describable|
        describable.description == describables[0].description
      end
    describables.count == identical_describables.count && describables.count > 1
  end
end
