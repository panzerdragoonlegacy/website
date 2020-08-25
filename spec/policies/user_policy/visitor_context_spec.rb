require 'rails_helper'

describe UserPolicy do
  subject { described_class.new(current_user, user) }

  let(:resolved_scope) do
    described_class::Scope.new(current_user, User.all).resolve
  end

  let(:current_user) { nil }

  context 'visitor accessing a user' do
    let(:user) { FactoryBot.create(:registered_user) }

    it 'excludes user from resolved scope' do
      expect(resolved_scope).not_to include(user)
    end

    it do
      is_expected.to forbid_actions(
        [:show, :new, :create, :edit, :update, :destroy]
      )
    end
  end
end
