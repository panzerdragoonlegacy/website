require 'rails_helper'

describe PagePolicy do
  subject { described_class.new(user, page) }

  let(:resolved_scope) { described_class::Scope.new(user, Page.all).resolve }

  let(:user) { FactoryBot.create(:registered_user) }

  context 'registered user creating a new page' do
    let(:page) { Page.new }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_attribute(:publish) }
  end

  context 'registered user accessing a published page' do
    let(:page) { FactoryBot.create(:published_page) }

    it 'includes page in resolved scope' do
      expect(resolved_scope).to include(page)
    end

    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_actions(%i[edit update destroy]) }
    it { is_expected.to forbid_attribute(:publish) }
  end

  context 'registered user accessing an unpublished page' do
    let(:page) { FactoryBot.create(:unpublished_page) }

    it 'excludes page from resolved scope' do
      expect(resolved_scope).not_to include(page)
    end

    it { is_expected.to forbid_actions(%i[show edit update destroy]) }
    it { is_expected.to forbid_attribute(:publish) }
  end
end
