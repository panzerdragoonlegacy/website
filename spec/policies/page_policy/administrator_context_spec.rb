require 'rails_helper'

describe PagePolicy do
  subject { described_class.new(user, page) }

  let(:resolved_scope) { described_class::Scope.new(user, Page.all).resolve }

  let(:user) { FactoryBot.create(:administrator) }

  context 'administrator creating a new page' do
    let(:page) { Page.new }

    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to permit_mass_assignment_of(:publish) }
  end

  context 'administrator accessing pages in a published category' do
    context 'accessing a published page' do
      let(:page) { FactoryBot.create(:published_page_in_published_category) }

      it 'includes page in resolved scope' do
        expect(resolved_scope).to include(page)
      end

      it { is_expected.to permit_actions(%i[show edit update destroy]) }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished page' do
      let(:page) { FactoryBot.create(:unpublished_page_in_published_category) }

      it 'includes page in resolved scope' do
        expect(resolved_scope).to include(page)
      end

      it { is_expected.to permit_actions(%i[show edit update destroy]) }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end
  end

  context 'administrator accessing pages in an unpublished category' do
    context 'accessing a published page' do
      let(:page) { FactoryBot.create(:published_page_in_unpublished_category) }

      it 'includes page in resolved scope' do
        expect(resolved_scope).to include(page)
      end

      it { is_expected.to permit_actions(%i[show edit update destroy]) }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished page' do
      let(:page) do
        FactoryBot.create(:unpublished_page_in_unpublished_category)
      end

      it 'includes page in resolved scope' do
        expect(resolved_scope).to include(page)
      end

      it { is_expected.to permit_actions(%i[show edit update destroy]) }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end
  end
end
