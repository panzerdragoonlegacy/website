require 'rails_helper'

RSpec.describe Category, type: :model do
  describe "fields" do
    it { should respond_to(:name) }
    it { should respond_to(:url) }
    it { should respond_to(:description) }
    it { should respond_to(:category_type) }
    it { should respond_to(:publish) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(100) }
    it { should validate_presence_of(:description) }
    it { 
      should validate_length_of(:description).is_at_least(2).is_at_most(250) 
    }
    it { should validate_presence_of(:category_type) }

    describe "validation of category type reassignment" do
      before do
        @category = FactoryGirl.create :category, category_type: :article
        @article = FactoryGirl.create :valid_article
      end

      context "category has children" do
        before do
          @category.articles << @article
        end

        context "category type has changed" do
          it "should not be valid" do
            @category.category_type = :download
            expect(@category).not_to be_valid
          end
        end

        context "category type has not changed" do
          it "should be valid" do
            expect(@category).to be_valid
          end
        end
      end

      context "category has no children" do
        context "category type has changed" do
          it "should be valid" do
            @category.category_type = :download
            expect(@category).to be_valid
          end
        end

        context "category type has not changed" do
          it "should be valid" do
            expect(@category).to be_valid
          end
        end
      end
    end

    describe "validation of category group" do
      context "category type is also a category group type" do
        before do
          @category_group = FactoryGirl.create(:category_group,
            category_group_type: :music_track)
          @category = FactoryGirl.build :category,
            category_type: :music_track
        end

        context "category group is present" do
          context "category type matches the group's type" do
            it "should be valid" do
              @category.category_group = @category_group
              expect(@category).to be_valid
            end
          end

          context "category type does not match the group's type" do
            it "should not be valid" do
              different_category_group = FactoryGirl.create(:category_group,
                category_group_type: :video)
              @category.category_group = different_category_group
              expect(@category).not_to be_valid
            end
          end
        end

        context "category group is missing" do
          it "should not be valid" do
            @category.category_group = nil
            expect(@category).not_to be_valid
          end
        end
      end

      context "category type is not a category group type" do
        before do
          @category = FactoryGirl.build :category, category_type: :article
        end

        it "should not validate if a category group is present" do
          category_group = FactoryGirl.create(:category_group,
            category_group_type: :music_track)
          @category.category_group = category_group
          expect(@category).not_to be_valid
        end

        it "should validate if a category group is missing" do
          @category.category_group = nil
          expect(@category).to be_valid
        end
      end
    end
  end

  describe "associations" do
    it { should belong_to(:category_group) }
    it { should have_many(:articles).dependent(:destroy) }
    it { should have_many(:downloads).dependent(:destroy) }
    it { should have_many(:encyclopaedia_entries).dependent(:destroy) }
    it { should have_many(:links).dependent(:destroy) }
    it { should have_many(:music_tracks).dependent(:destroy) }
    it { should have_many(:pictures).dependent(:destroy) }
    it { should have_many(:resources).dependent(:destroy) }
    it { should have_many(:stories).dependent(:destroy) }
    it { should have_many(:videos).dependent(:destroy) }
  end
end
