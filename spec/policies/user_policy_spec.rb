require 'rails_helper'

describe UserPolicy do
  subject { UserPolicy.new(current_user, user) }

  let(:resolved_scope) do
    UserPolicy::Scope.new(current_user, User.all).resolve
  end

  context 'being a visitor' do
    let(:current_user) { nil }

    context 'accessing a user' do
      let(:user) { FactoryGirl.create(:registered_user) }

      it 'excludes user from resolved scope' do
        expect(resolved_scope).not_to include(user)
      end

      it { should forbid_action(:show) }
      it { should forbid_new_and_create_actions }
      it { should forbid_edit_and_update_actions }
      it { should forbid_action(:destroy) }
    end
  end

  context 'being a registered user' do
    let(:current_user) { FactoryGirl.create(:registered_user) }

    context 'accessing a user' do
      let(:user) { FactoryGirl.create(:registered_user) }

      it 'excludes user from resolved scope' do
        expect(resolved_scope).not_to include(user)
      end

      it { should forbid_action(:show) }
      it { should forbid_new_and_create_actions }
      it { should forbid_edit_and_update_actions }
      it { should forbid_action(:destroy) }
    end
  end

  context 'being an administrator' do
    let(:current_user) { FactoryGirl.create(:administrator) }

    context 'accessing a user' do
      let(:user) { FactoryGirl.create(:registered_user) }

      it 'includes user in resolved scope' do
        expect(resolved_scope).to include(user)
      end

      it { should permit_action(:show) }
      it { should permit_new_and_create_actions }
      it { should permit_edit_and_update_actions }
      it { should permit_action(:destroy) }
    end
  end
end
