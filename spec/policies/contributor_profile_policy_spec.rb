require 'rails_helper'

describe ContributorProfilePolicy do
  subject { ContributorProfilePolicy.new(user, contributor_profile) }

  let(:resolved_scope) do
    ContributorProfilePolicy::Scope.new(user, ContributorProfile.all).resolve
  end

  context 'being a visitor' do
    let(:user) { nil }

    context 'accessing a contributor profile' do
      let(:contributor_profile) do
        FactoryGirl.create(:contributor_profile)
      end

      it 'includes contributor profile in resolved scope' do
        expect(resolved_scope).to include(contributor_profile)
      end

      it { should permit_action(:show) }
      it { should forbid_new_and_create_actions }
      it { should forbid_edit_and_update_actions }
      it { should forbid_action(:destroy) }
    end
  end

  context 'being a registered user' do
    let(:user) { FactoryGirl.create(:registered_user) }

    context 'accessing a contributor profile' do
      let(:contributor_profile) do
        FactoryGirl.create(:contributor_profile)
      end

      it 'includes contributor profile in resolved scope' do
        expect(resolved_scope).to include(contributor_profile)
      end

      it { should permit_action(:show) }
      it { should forbid_new_and_create_actions }
      it { should forbid_edit_and_update_actions }
      it { should forbid_action(:destroy) }
    end
  end

  context 'being an administrator' do
    let(:user) { FactoryGirl.create(:administrator) }

    context 'accessing a contributor profile' do
      let(:contributor_profile) do
        FactoryGirl.create(:contributor_profile)
      end

      it 'includes contributor profile in resolved scope' do
        expect(resolved_scope).to include(contributor_profile)
      end

      it { should permit_action(:show) }
      it { should permit_new_and_create_actions }
      it { should permit_edit_and_update_actions }
      it { should permit_action(:destroy) }
    end
  end
end
