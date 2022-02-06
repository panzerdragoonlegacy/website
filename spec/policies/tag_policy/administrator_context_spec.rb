require 'rails_helper'

describe TagPolicy do
  subject { described_class.new(user, tag) }

  let(:resolved_scope) { described_class::Scope.new(user, Tag.all).resolve }

  let(:user) { FactoryBot.create(:administrator) }

  context 'administrator accessing a tag' do
    let(:tag) { FactoryBot.create(:valid_tag) }

    it 'includes tag in resolved scope' do
      expect(resolved_scope).to include(tag)
    end

    it do
      is_expected.to permit_actions(%i[show new create edit update destroy])
    end
  end
end
