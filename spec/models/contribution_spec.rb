require 'rails_helper'

RSpec.describe Contribution, type: :model do
  describe "associations" do
    it { should belong_to(:dragoon) }
    it { should belong_to(:contributable) }
  end
end
