require 'rails_helper'

describe PicturePolicy do
  subject { described_class.new(user, picture) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Picture.all).resolve
  end

  context 'being an administrator' do
    let(:user) { FactoryGirl.create(:administrator) }

    context 'creating a new picture' do
      let(:picture) { Picture.new }

      it { is_expected.to permit_new_and_create_actions }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end

    context 'accessing pictures in a published category' do
      context 'accessing a published picture' do
        let(:picture) do
          FactoryGirl.create(:published_picture_in_published_category)
        end

        it 'includes picture in resolved scope' do
          expect(resolved_scope).to include(picture)
        end

        it { is_expected.to permit_action(:show) }
        it { is_expected.to permit_edit_and_update_actions }
        it { is_expected.to permit_action(:destroy) }
        it { is_expected.to permit_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished picture' do
        let(:picture) do
          FactoryGirl.create(:unpublished_picture_in_published_category)
        end

        it 'includes picture in resolved scope' do
          expect(resolved_scope).to include(picture)
        end

        it { is_expected.to permit_action(:show) }
        it { is_expected.to permit_edit_and_update_actions }
        it { is_expected.to permit_action(:destroy) }
        it { is_expected.to permit_mass_assignment_of(:publish) }
      end
    end

    context 'accessing pictures in an unpublished category' do
      context 'accessing a published picture' do
        let(:picture) do
          FactoryGirl.create(:published_picture_in_unpublished_category)
        end

        it 'includes picture in resolved scope' do
          expect(resolved_scope).to include(picture)
        end

        it { is_expected.to permit_action(:show) }
        it { is_expected.to permit_edit_and_update_actions }
        it { is_expected.to permit_action(:destroy) }
        it { is_expected.to permit_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished picture' do
        let(:picture) do
          FactoryGirl.create(:unpublished_picture_in_unpublished_category)
        end

        it 'includes picture in resolved scope' do
          expect(resolved_scope).to include(picture)
        end

        it { is_expected.to permit_action(:show) }
        it { is_expected.to permit_edit_and_update_actions }
        it { is_expected.to permit_action(:destroy) }
        it { is_expected.to permit_mass_assignment_of(:publish) }
      end
    end
  end
end
