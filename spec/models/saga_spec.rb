require 'rails_helper'

RSpec.describe Saga, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:url) }
    it { is_expected.to respond_to(:sequence_number) }
    it { is_expected.to respond_to(:encyclopaedia_entry) }
    it { is_expected.to respond_to(:created_at) }
    it { is_expected.to respond_to(:updated_at) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:encyclopaedia_entry) }
    it { is_expected.to have_many(:categories).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it do
      is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(30)
    end
    it { is_expected.to validate_presence_of(:sequence_number) }
    it do
      is_expected.to validate_numericality_of(:sequence_number)
        .is_greater_than(0).is_less_than(100)
    end

    describe 'validation of encyclopaedia entry' do
      context 'creating a new saga' do
        before do
          @encyclopaedia_entry = FactoryGirl.create(:valid_encyclopaedia_entry)
        end

        context 'encyclopaedia entry is associated with another saga' do
          before do
            @another_saga = FactoryGirl.create(
              :valid_saga,
              encyclopaedia_entry: @encyclopaedia_entry
            )
            @saga = FactoryGirl.build(
              :valid_saga,
              encyclopaedia_entry: @encyclopaedia_entry
            )
          end

          it 'should not be valid' do
            expect(@saga).not_to be_valid
          end
        end

        context 'encyclopaedia entry is not associated with another saga' do
          before do
            @saga = FactoryGirl.build(
              :valid_saga,
              encyclopaedia_entry: @encyclopaedia_entry
            )
          end

          it 'should be valid' do
            expect(@saga).to be_valid
          end
        end
      end

      context 'updating an existing saga with a new encyclopaedia entry' do
        before do
          @old_encyclopaedia_entry = FactoryGirl.create(
            :valid_encyclopaedia_entry
          )
          @new_encyclopaedia_entry = FactoryGirl.create(
            :valid_encyclopaedia_entry
          )
        end

        context 'new encyclopaedia entry is associated with another saga' do
          before do
            @another_saga = FactoryGirl.create(
              :valid_saga,
              encyclopaedia_entry: @new_encyclopaedia_entry
            )
            @saga = FactoryGirl.create(
              :valid_saga,
              encyclopaedia_entry: @old_encyclopaedia_entry
            )
          end

          it 'should not be valid' do
            @saga.encyclopaedia_entry = @new_encyclopaedia_entry
            expect(@saga).not_to be_valid
          end
        end

        context 'new encyclopaedia entry is not associated with another saga' do
          before do
            @saga = FactoryGirl.create(
              :valid_saga,
              encyclopaedia_entry: @old_encyclopaedia_entry
            )
          end

          it 'should be valid' do
            @saga.encyclopaedia_entry = @new_encyclopaedia_entry
            expect(@saga).to be_valid
          end
        end

        context 'new encyclopaedia entry is already associated with the saga' do
          before do
            @saga = FactoryGirl.create(
              :valid_saga,
              encyclopaedia_entry: @new_encyclopaedia_entry
            )
          end

          it 'should be valid' do
            @saga.encyclopaedia_entry = @new_encyclopaedia_entry
            expect(@saga).to be_valid
          end
        end
      end
    end
  end

  describe 'slug' do
    context 'creating a new saga' do
      let(:saga) do
        FactoryGirl.build :valid_saga, name: 'Saga 1'
      end

      it 'generates a slug that is a parameterised version of the name' do
        saga.save
        expect(saga.url).to eq 'saga-1'
      end
    end

    context 'updating a saga' do
      let(:saga) do
        FactoryGirl.create :valid_saga, name: 'Saga 1'
      end

      it 'synchronises the slug with the updated name' do
        saga.name = 'Saga 2'
        saga.save
        expect(saga.url).to eq 'saga-2'
      end
    end
  end
end
