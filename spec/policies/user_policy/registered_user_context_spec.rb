require 'rails_helper'

describe UserPolicy do
  subject { described_class.new(current_user, user) }

  let(:resolved_scope) do
    described_class::Scope.new(current_user, User.all).resolve
  end

  context 'being a registered user' do
    let(:current_user) { FactoryGirl.create(:registered_user) }

    context 'accessing a user' do
      let(:user) { FactoryGirl.create(:registered_user) }

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
end
