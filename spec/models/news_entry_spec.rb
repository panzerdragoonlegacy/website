require 'rails_helper'

RSpec.describe NewsEntry, type: :model do
  describe "fields" do
    it { should respond_to(:name) }
    it { should respond_to(:url) }
    it { should respond_to(:content) }
    it { should respond_to(:short_url) }
    it { should respond_to(:publish) }
    it { should respond_to(:dragoon) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
    it { should respond_to(:published_at) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(55) }
    it { should validate_presence_of(:content) }
  end

  describe "associations" do
    it { should belong_to(:dragoon) }
  end
end
