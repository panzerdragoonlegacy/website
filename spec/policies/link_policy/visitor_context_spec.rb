require 'rails_helper'

describe LinkPolicy do
  subject { described_class.new(user, link) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Link.all).resolve
  end

  context 'being a visitor' do
    let(:user) { nil }

    context 'accessing a link in a published category' do
      let(:link) { FactoryGirl.create(:link_in_published_category) }

      it 'includes link in resolved scope' do
        expect(resolved_scope).to include(link)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_new_and_create_actions }
      it { is_expected.to forbid_edit_and_update_actions }
      it { is_expected.to forbid_action(:destroy) }
    end

    context 'accessing a link in an unpublished category' do
      let(:link) { FactoryGirl.create(:link_in_unpublished_category) }

      it 'excludes link from resolved scope' do
        expect(resolved_scope).not_to include(link)
      end

      it { is_expected.to forbid_action(:show) }
      it { is_expected.to forbid_new_and_create_actions }
      it { is_expected.to forbid_edit_and_update_actions }
      it { is_expected.to forbid_action(:destroy) }
    end
  end
end
