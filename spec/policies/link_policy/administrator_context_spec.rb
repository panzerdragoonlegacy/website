require 'rails_helper'

describe LinkPolicy do
  subject { described_class.new(user, link) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Link.all).resolve
  end

  context 'being an administrator' do
    let(:user) { FactoryGirl.create(:administrator) }

    context 'accessing links in a published category' do
      let(:link) { FactoryGirl.create(:link_in_published_category) }

      it 'includes link in resolved scope' do
        expect(resolved_scope).to include(link)
      end

      it { is_expected.to permit_actions([:show, :edit, :update, :destroy]) }
      it { is_expected.to permit_action(:destroy) }
    end

    context 'accessing links in an unpublished category' do
      let(:link) { FactoryGirl.create(:link_in_unpublished_category) }

      it 'includes link in resolved scope' do
        expect(resolved_scope).to include(link)
      end

      it { is_expected.to permit_actions([:show, :edit, :update, :destroy]) }
      it { is_expected.to permit_action(:destroy) }
    end
  end
end
