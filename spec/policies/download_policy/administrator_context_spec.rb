require 'rails_helper'

describe DownloadPolicy do
  subject { described_class.new(user, download) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Download.all).resolve
  end

  context 'being an administrator' do
    let(:user) { FactoryGirl.create(:administrator) }

    context 'creating a new download' do
      let(:download) { Download.new }

      it { is_expected.to permit_new_and_create_actions }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end

    context 'accessing downloads in a published category' do
      context 'accessing a published download' do
        let(:download) do
          FactoryGirl.create(:published_download_in_published_category)
        end

        it 'includes download in resolved scope' do
          expect(resolved_scope).to include(download)
        end

        it { is_expected.to permit_action(:show) }
        it { is_expected.to permit_edit_and_update_actions }
        it { is_expected.to permit_action(:destroy) }
        it { is_expected.to permit_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished download' do
        let(:download) do
          FactoryGirl.create(:unpublished_download_in_published_category)
        end

        it 'includes download in resolved scope' do
          expect(resolved_scope).to include(download)
        end

        it { is_expected.to permit_action(:show) }
        it { is_expected.to permit_edit_and_update_actions }
        it { is_expected.to permit_action(:destroy) }
        it { is_expected.to permit_mass_assignment_of(:publish) }
      end
    end

    context 'accessing downloads in an unpublished category' do
      context 'accessing a published download' do
        let(:download) do
          FactoryGirl.create(:published_download_in_unpublished_category)
        end

        it 'includes download in resolved scope' do
          expect(resolved_scope).to include(download)
        end

        it { is_expected.to permit_action(:show) }
        it { is_expected.to permit_edit_and_update_actions }
        it { is_expected.to permit_action(:destroy) }
        it { is_expected.to permit_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished download' do
        let(:download) do
          FactoryGirl.create(:unpublished_download_in_unpublished_category)
        end

        it 'includes download in resolved scope' do
          expect(resolved_scope).to include(download)
        end

        it { is_expected.to permit_action(:show) }
        it { is_expected.to permit_edit_and_update_actions }
        it { is_expected.to permit_action(:destroy) }
        it { is_expected.to permit_mass_assignment_of(:publish) }
      end
    end
  end
end