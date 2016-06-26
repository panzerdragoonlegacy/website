require 'rails_helper'

describe PagePolicy do
  subject { described_class.new(user, page) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Page.all).resolve
  end

  context 'being a visitor' do
    let(:user) { nil }

    context 'creating a new page' do
      let(:page) { Page.new }

      it { is_expected.to forbid_new_and_create_actions }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing a published page' do
      let(:page) do
        FactoryGirl.create(:published_page)
      end

      it 'includes page in resolved scope' do
        expect(resolved_scope).to include(page)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_edit_and_update_actions }
      it { is_expected.to forbid_action(:destroy) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished page' do
      let(:page) do
        FactoryGirl.create(:unpublished_page)
      end

      it 'excludes page from resolved scope' do
        expect(resolved_scope).not_to include(page)
      end

      it { is_expected.to forbid_action(:show) }
      it { is_expected.to forbid_edit_and_update_actions }
      it { is_expected.to forbid_action(:destroy) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end
  end

  context 'being a registered user' do
    let(:user) { FactoryGirl.create(:registered_user) }

    context 'creating a new page' do
      let(:page) { Page.new }

      it { is_expected.to forbid_new_and_create_actions }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing a published page' do
      let(:page) do
        FactoryGirl.create(:published_page)
      end

      it 'includes page in resolved scope' do
        expect(resolved_scope).to include(page)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_edit_and_update_actions }
      it { is_expected.to forbid_action(:destroy) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished page' do
      let(:page) do
        FactoryGirl.create(:unpublished_page)
      end

      it 'excludes page from resolved scope' do
        expect(resolved_scope).not_to include(page)
      end

      it { is_expected.to forbid_action(:show) }
      it { is_expected.to forbid_edit_and_update_actions }
      it { is_expected.to forbid_action(:destroy) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end
  end

  context 'being an administrator' do
    let(:user) { FactoryGirl.create(:administrator) }

    context 'creating a new page' do
      let(:page) { Page.new }

      it { is_expected.to permit_new_and_create_actions }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end

    context 'accessing a published page' do
      let(:page) do
        FactoryGirl.create(:published_page)
      end

      it 'includes page in resolved scope' do
        expect(resolved_scope).to include(page)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to permit_edit_and_update_actions }
      it { is_expected.to permit_action(:destroy) }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished page' do
      let(:page) do
        FactoryGirl.create(:unpublished_page)
      end

      it 'includes page in resolved scope' do
        expect(resolved_scope).to include(page)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to permit_edit_and_update_actions }
      it { is_expected.to permit_action(:destroy) }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end
  end
end
