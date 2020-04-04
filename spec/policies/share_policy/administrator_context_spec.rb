require 'rails_helper'

describe SharePolicy do
  subject { described_class.new(user, share) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Share.all).resolve
  end

  let(:user) { FactoryGirl.create(:administrator) }

  context 'administrator accessing a share' do
    let(:share) { FactoryGirl.create(:valid_share) }

    it 'includes share in resolved scope' do
      expect(resolved_scope).to include(share)
    end

    it do
      is_expected.to permit_actions(%i(show new create edit update destroy))
    end
  end
end
