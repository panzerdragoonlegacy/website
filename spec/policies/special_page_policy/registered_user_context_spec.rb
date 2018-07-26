require 'rails_helper'

describe SpecialPagePolicy do
  subject { described_class.new(user, special_page) }

  let(:resolved_scope) do
    described_class::Scope.new(user, SpecialPage.all).resolve
  end

  let(:user) { FactoryGirl.create(:registered_user) }

  context 'registered user creating a new special page' do
    let(:special_page) { SpecialPage.new }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_mass_assignment_of(:publish) }
  end

  context 'registered user accessing a published special page' do
    let(:special_page) do
      FactoryGirl.create(:published_special_page)
    end

    it 'includes special page in resolved scope' do
      expect(resolved_scope).to include(special_page)
    end

    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_actions([:edit, :update, :destroy]) }
    it { is_expected.to forbid_mass_assignment_of(:publish) }
  end

  context 'registered user accessing an unpublished special page' do
    let(:special_page) do
      FactoryGirl.create(:unpublished_special_page)
    end

    it 'excludes special page from resolved scope' do
      expect(resolved_scope).not_to include(special_page)
    end

    it { is_expected.to forbid_actions([:show, :edit, :update, :destroy]) }
    it { is_expected.to forbid_mass_assignment_of(:publish) }
  end
end
