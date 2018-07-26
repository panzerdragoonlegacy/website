require 'rails_helper'

describe TagPolicy do
  subject { described_class.new(user, tag) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Tag.all).resolve
  end

  let(:user) { FactoryGirl.create(:registered_user) }

  context 'registered user accessing a tag' do
    let(:tag) { FactoryGirl.create(:valid_tag) }

    it 'includes tag in resolved scope' do
      expect(resolved_scope).to include(tag)
    end

    it do
      is_expected.to forbid_actions([
        :show, :new, :create, :edit, :update, :destroy
      ])
    end
  end
end
