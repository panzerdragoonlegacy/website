require 'rails_helper'

RSpec.describe Illustration, type: :model do
  describe "fields" do
    it { should respond_to(:illustration) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end

  describe "associations" do
    it { should belong_to(:illustratable) }
  end
end
