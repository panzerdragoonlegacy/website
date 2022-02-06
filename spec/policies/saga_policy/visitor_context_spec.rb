require 'rails_helper'

describe SagaPolicy do
  subject { described_class.new(user, saga) }

  let(:resolved_scope) { described_class::Scope.new(user, Saga.all).resolve }

  let(:user) { nil }

  context 'visitor accessing a saga' do
    let(:saga) { FactoryBot.create(:valid_saga) }

    it 'includes saga in resolved scope' do
      expect(resolved_scope).to include(saga)
    end

    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_actions(%i[new create edit update destroy]) }
  end
end
