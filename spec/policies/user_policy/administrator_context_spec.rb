require 'rails_helper'

describe UserPolicy do
  subject { described_class.new(current_user, user) }

  let(:resolved_scope) do
    described_class::Scope.new(current_user, User.all).resolve
  end

  context 'being an administrator' do
    let(:current_user) { FactoryGirl.create(:administrator) }

    context 'accessing a user' do
      let(:user) { FactoryGirl.create(:registered_user) }

      it 'includes user in resolved scope' do
        expect(resolved_scope).to include(user)
      end

      it do
        is_expected.to permit_actions(
          [:show, :new, :create, :edit, :update, :destroy]
        )
      end
    end
  end
end
