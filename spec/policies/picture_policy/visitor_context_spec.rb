require 'rails_helper'

describe PicturePolicy do
  subject { described_class.new(user, picture) }

  let(:resolved_scope) { described_class::Scope.new(user, Picture.all).resolve }

  let(:user) { nil }

  context 'visitor creating a new picture' do
    let(:picture) { Picture.new }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_attribute(:publish) }
  end

  context 'visitor accessing a published picture' do
    let(:picture) { FactoryBot.create(:published_picture) }

    it 'includes picture in resolved scope' do
      expect(resolved_scope).to include(picture)
    end

    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_actions(%i[edit update destroy]) }
    it { is_expected.to forbid_attribute(:publish) }
  end

  context 'visitor accessing an unpublished picture' do
    let(:picture) { FactoryBot.create(:unpublished_picture) }

    it 'excludes picture from resolved scope' do
      expect(resolved_scope).not_to include(picture)
    end

    it { is_expected.to forbid_actions(%i[show edit update destroy]) }
    it { is_expected.to forbid_attribute(:publish) }
  end
end
