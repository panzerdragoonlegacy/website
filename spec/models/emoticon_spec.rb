require 'rails_helper'

RSpec.describe Emoticon, type: :model do
  describe "fields" do
    it { should respond_to(:name) }
    it { should respond_to(:code) }
    it { should respond_to(:emoticon) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should ensure_length_of(:name).is_at_least(2).is_at_most(25) }
  end

  pending describe "methods" do
    context "before save" do
      it "should set the code to a lowercase verion of the name surrounded by colons" do
      end
    end
  end
end
