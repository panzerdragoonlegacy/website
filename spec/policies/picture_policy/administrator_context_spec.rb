require 'rails_helper'

describe PicturePolicy do
  subject { described_class.new(user, picture) }

  let(:resolved_scope) { described_class::Scope.new(user, Picture.all).resolve }

  let(:user) { FactoryBot.create(:administrator) }

  context 'administrator creating a new picture' do
    let(:picture) { Picture.new }

    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to permit_mass_assignment_of(:publish) }
  end

  context 'administrator accessing pictures in a published category' do
    context 'accessing a published picture' do
      let(:picture) do
        FactoryBot.create(:published_picture_in_published_category)
      end

      it 'includes picture in resolved scope' do
        expect(resolved_scope).to include(picture)
      end

      it { is_expected.to permit_actions(%i[show edit update destroy]) }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished picture' do
      let(:picture) do
        FactoryBot.create(:unpublished_picture_in_published_category)
      end

      it 'includes picture in resolved scope' do
        expect(resolved_scope).to include(picture)
      end

      it { is_expected.to permit_actions(%i[show edit update destroy]) }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end
  end

  context 'administrator accessing pictures in an unpublished category' do
    context 'accessing a published picture' do
      let(:picture) do
        FactoryBot.create(:published_picture_in_unpublished_category)
      end

      it 'includes picture in resolved scope' do
        expect(resolved_scope).to include(picture)
      end

      it { is_expected.to permit_actions(%i[show edit update destroy]) }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished picture' do
      let(:picture) do
        FactoryBot.create(:unpublished_picture_in_unpublished_category)
      end

      it 'includes picture in resolved scope' do
        expect(resolved_scope).to include(picture)
      end

      it { is_expected.to permit_actions(%i[show edit update destroy]) }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end
  end
end
