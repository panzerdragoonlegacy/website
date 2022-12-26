require 'rails_helper'

describe VideoPolicy do
  subject { described_class.new(user, video) }

  let(:resolved_scope) { described_class::Scope.new(user, Video.all).resolve }

  let(:user) { FactoryBot.create(:administrator) }

  context 'creating a new video' do
    let(:video) { Video.new }

    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to permit_mass_assignment_of(:publish) }
  end

  context 'administrator accessing a published video' do
    let(:video) { FactoryBot.create(:published_video) }

    it 'includes video in resolved scope' do
      expect(resolved_scope).to include(video)
    end

    it { is_expected.to permit_actions(%i[show edit update destroy]) }
    it { is_expected.to permit_mass_assignment_of(:publish) }
  end

  context 'administrator accessing an unpublished video' do
    let(:video) { FactoryBot.create(:unpublished_video) }

    it 'includes video in resolved scope' do
      expect(resolved_scope).to include(video)
    end

    it { is_expected.to permit_actions(%i[show edit update destroy]) }
    it { is_expected.to permit_mass_assignment_of(:publish) }
  end
end
