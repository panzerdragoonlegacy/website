require 'rails_helper'

describe PagePolicy do
  subject { described_class.new(user, page) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Page.all).resolve
  end

  let(:user) { FactoryBot.create(:registered_user) }

  context 'registered user creating a new page' do
    let(:page) { Page.new }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_mass_assignment_of(:publish) }
  end

  context 'registered user accessing pages in a published category' do
    context 'accessing a published page' do
      let(:page) do
        FactoryBot.create(:published_page_in_published_category)
      end

      it 'includes page in resolved scope' do
        expect(resolved_scope).to include(page)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_actions(%i(edit update destroy)) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished page' do
      let(:page) do
        FactoryBot.create(:unpublished_page_in_published_category)
      end

      it 'excludes page from resolved scope' do
        expect(resolved_scope).not_to include(page)
      end

      it { is_expected.to forbid_actions(%i(show edit update destroy)) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end
  end

  context 'registered user accessing pages in an unpublished category' do
    context 'accessing a published page' do
      let(:page) do
        FactoryBot.create(:published_page_in_unpublished_category)
      end

      it 'excludes page from resolved scope' do
        expect(resolved_scope).not_to include(page)
      end

      it { is_expected.to forbid_actions(%i(show edit update destroy)) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished page' do
      let(:page) do
        FactoryBot.create(:unpublished_page_in_unpublished_category)
      end

      it 'excludes page from resolved scope' do
        expect(resolved_scope).not_to include(page)
      end

      it { is_expected.to forbid_actions(%i(show edit update destroy)) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end
  end
end
