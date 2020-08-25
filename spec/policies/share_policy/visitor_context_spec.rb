require 'rails_helper'

describe SharePolicy do
  subject { described_class.new(user, share) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Share.all).resolve
  end

  let(:user) { nil }

  context 'visitor accessing a share' do
    let(:share) { FactoryBot.create(:valid_share) }

    it 'includes share in resolved scope' do
      expect(resolved_scope).to include(share)
    end

    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_actions(%i(new create edit update destroy)) }
  end
end
