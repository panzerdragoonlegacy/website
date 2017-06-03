require 'rails_helper'

describe PagePolicy do
  subject { described_class.new(user, page) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Page.all).resolve
  end

  let(:user) { FactoryGirl.create(:administrator) }

  context 'administrator creating a new page' do
    let(:page) { Page.new }

    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to permit_mass_assignment_of(:publish) }
  end

  context 'administrator accessing a published page' do
    let(:page) do
      FactoryGirl.create(:published_page)
    end

    it 'includes page in resolved scope' do
      expect(resolved_scope).to include(page)
    end

    it { is_expected.to permit_actions([:show, :edit, :update, :destroy]) }
    it { is_expected.to permit_mass_assignment_of(:publish) }
  end

  context 'administrator accessing an unpublished page' do
    let(:page) do
      FactoryGirl.create(:unpublished_page)
    end

    it 'includes page in resolved scope' do
      expect(resolved_scope).to include(page)
    end

    it { is_expected.to permit_actions([:show, :edit, :update, :destroy]) }
    it { is_expected.to permit_mass_assignment_of(:publish) }
  end
end
