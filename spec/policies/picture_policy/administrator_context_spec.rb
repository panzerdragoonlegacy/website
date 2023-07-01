require 'rails_helper'

describe PicturePolicy do
  subject { described_class.new(user, picture) }

  let(:resolved_scope) { described_class::Scope.new(user, Picture.all).resolve }

  let(:user) { FactoryBot.create(:administrator) }

  context 'administrator creating a new picture' do
    let(:picture) { Picture.new }

    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to permit_attribute(:publish) }
  end

  context 'administrator accessing a published picture' do
    let(:picture) { FactoryBot.create(:published_picture) }

    it 'includes picture in resolved scope' do
      expect(resolved_scope).to include(picture)
    end

    it { is_expected.to permit_actions(%i[show edit update destroy]) }
    it { is_expected.to permit_attribute(:publish) }
  end

  context 'administrator accessing an unpublished picture' do
    let(:picture) { FactoryBot.create(:unpublished_picture) }

    it 'includes picture in resolved scope' do
      expect(resolved_scope).to include(picture)
    end

    it { is_expected.to permit_actions(%i[show edit update destroy]) }
    it { is_expected.to permit_attribute(:publish) }
  end
end
