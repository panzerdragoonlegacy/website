require 'rails_helper'

describe LinkPolicy do
  subject { described_class.new(user, link) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Link.all).resolve
  end

  let(:user) { nil }

  context 'visitor accessing a link in a published category' do
    let(:link) { FactoryGirl.create(:link_in_published_category) }

    it 'includes link in resolved scope' do
      expect(resolved_scope).to include(link)
    end

    it { is_expected.to permit_action(:show) }
    it do
      is_expected.to forbid_actions([:new, :create, :edit, :update, :destroy])
    end
  end

  context 'visitor accessing a link in an unpublished category' do
    let(:link) { FactoryGirl.create(:link_in_unpublished_category) }

    it 'excludes link from resolved scope' do
      expect(resolved_scope).not_to include(link)
    end

    it do
      is_expected.to forbid_actions(
        [:show, :new, :create, :edit, :update, :destroy]
      )
    end
  end
end
