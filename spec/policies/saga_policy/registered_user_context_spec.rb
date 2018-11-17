require 'rails_helper'

describe SagaPolicy do
  subject { described_class.new(user, saga) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Saga.all).resolve
  end

  let(:user) { FactoryGirl.create(:registered_user) }

  context 'registered user accessing a saga' do
    let(:saga) do
      FactoryGirl.create(:valid_saga)
    end

    it 'includes saga in resolved scope' do
      expect(resolved_scope).to include(saga)
    end

    it { is_expected.to permit_action(:show) }
    it do
      is_expected.to forbid_actions([:new, :create, :edit, :update, :destroy])
    end
  end
end
