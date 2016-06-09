require 'rails_helper'

RSpec.describe Contribution, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:contributor_profile) }
    it { is_expected.to belong_to(:contributable) }
  end
end
