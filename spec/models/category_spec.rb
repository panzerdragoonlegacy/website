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
    it { should validate_length_of(:description).is_at_least(2).is_at_most(250) }
  end

  describe "associations" do
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
