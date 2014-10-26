require 'rails_helper'

RSpec.describe Link, type: :model do
  describe "fields" do
    it { should respond_to(:name) }
    it { should respond_to(:url) }
    it { should respond_to(:description) }
    it { should respond_to(:partner_site) }
    it { should respond_to(:category) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should ensure_length_of(:name).is_at_least(2).is_at_most(100) }
    it { should validate_presence_of(:description) }
    it { should ensure_length_of(:description).is_at_least(2).is_at_most(250) }
    it { should validate_presence_of(:category) }
  end

  describe "associations" do
    it { should belong_to(:category) }
    it { should have_many(:contributions).dependent(:destroy) }
    it { should have_many(:dragoons).through(:contributions) }
    it { should have_many(:relations).dependent(:destroy) }
    it { should have_many(:encyclopaedia_entries).through(:relations) }
  end
end
