require 'rails_helper'

describe PoemPolicy do
  subject { described_class.new(user, poem) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Poem.all).resolve
  end

  context 'being a registered user' do
    let(:user) { FactoryGirl.create(:registered_user) }

    context 'creating a new poem' do
      let(:poem) { Poem.new }

      it { is_expected.to forbid_new_and_create_actions }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing a published poem' do
      let(:poem) { FactoryGirl.create(:published_poem) }

      it 'includes poem in resolved scope' do
        expect(resolved_scope).to include(poem)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_actions([:edit, :update, :destroy]) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished poem' do
      let(:poem) { FactoryGirl.create(:unpublished_poem) }

      it 'excludes poem from resolved scope' do
        expect(resolved_scope).not_to include(poem)
      end

      it { is_expected.to forbid_actions([:show, :edit, :update, :destroy]) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end
  end
end
