require 'rails_helper'

describe PicturePolicy do
  subject { described_class.new(user, picture) }

  let(:resolved_scope) { described_class::Scope.new(user, Picture.all).resolve }

  let(:contributor_profile) { FactoryBot.create(:valid_contributor_profile) }
  let(:user) do
    FactoryBot.create(:contributor, contributor_profile: contributor_profile)
  end

  context 'contributor creating a new picture' do
    let(:picture) { Picture.new }

    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to forbid_attribute(:publish) }
  end

  context 'contributor accessing pictures that they do not contribute to' do
    context 'accessing a published picture' do
      let(:picture) { FactoryBot.create(:published_picture) }

      it 'includes picture in resolved scope' do
        expect(resolved_scope).to include(picture)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_actions(%i[edit update destroy]) }
      it { is_expected.to forbid_attribute(:publish) }
    end

    context 'accessing an unpublished picture' do
      let(:picture) { FactoryBot.create(:unpublished_picture) }

      it 'excludes picture from resolved scope' do
        expect(resolved_scope).not_to include(picture)
      end

      it { is_expected.to forbid_actions(%i[show edit update destroy]) }
      it { is_expected.to forbid_attribute(:publish) }
    end
  end

  context 'contributor accessing pictures that they contribute to' do
    context 'accessing a published picture' do
      let(:picture) do
        FactoryBot.create(
          :published_picture,
          contributions: [
            Contribution.new(contributor_profile: contributor_profile)
          ]
        )
      end

      it 'includes picture in resolved scope' do
        expect(resolved_scope).to include(picture)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_actions(%i[edit update destroy]) }
      it { is_expected.to forbid_attribute(:publish) }
    end

    context 'accessing an unpublished picture' do
      let(:picture) do
        FactoryBot.create(
          :unpublished_picture,
          contributions: [
            Contribution.new(contributor_profile: contributor_profile)
          ]
        )
      end

      it 'includes picture in resolved scope' do
        expect(resolved_scope).to include(picture)
      end

      it { is_expected.to permit_actions(%i[show edit update destroy]) }
      it { is_expected.to forbid_attribute(:publish) }
    end
  end
end
