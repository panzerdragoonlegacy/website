require 'rails_helper'

describe PoemPolicy do
  subject { PoemPolicy.new(user, poem) }

  let(:resolved_scope) {
    PoemPolicy::Scope.new(user, Poem.all).resolve
  }

  context "being a visitor" do
    let(:user) { nil }

    context "accessing a published poem" do
      let(:poem) { FactoryGirl.create(:published_poem) }

      it "includes poem in resolved scope" do
        expect(resolved_scope).to include(poem)
      end

      it { should permit_action(:show) }
      it { should forbid_new_and_create }
      it { should forbid_edit_and_update }
      it { should forbid_action(:destroy) }
    end

    context "accessing an unpublished poem" do
      let(:poem) { FactoryGirl.create(:unpublished_poem) }

      it "excludes poem from resolved scope" do
        expect(resolved_scope).not_to include(poem)
      end

      it { should forbid_action(:show) }
      it { should forbid_new_and_create }
      it { should forbid_edit_and_update }
      it { should forbid_action(:destroy) }
    end
  end

  context "being a registered user" do
    let(:user) { FactoryGirl.create(:registered_user) }

    context "accessing a published poem" do
      let(:poem) { FactoryGirl.create(:published_poem) }

      it "includes poem in resolved scope" do
        expect(resolved_scope).to include(poem)
      end

      it { should permit_action(:show) }
      it { should forbid_new_and_create }
      it { should forbid_edit_and_update }
      it { should forbid_action(:destroy) }
    end

    context "accessing an unpublished poem" do
      let(:poem) { FactoryGirl.create(:unpublished_poem) }

      it "excludes poem from resolved scope" do
        expect(resolved_scope).not_to include(poem)
      end

      it { should forbid_action(:show) }
      it { should forbid_new_and_create }
      it { should forbid_edit_and_update }
      it { should forbid_action(:destroy) }
    end
  end

  context "being a contributor" do
    let(:contributor_profile) {
      FactoryGirl.create(:contributor_profile)
    }
    let(:user) {
      FactoryGirl.create(
        :contributor, 
        contributor_profile: contributor_profile
      )
    }

    context "accessing poems that the user does not contribute to" do
      context "accessing a published poem" do
        let(:poem) { FactoryGirl.create(:published_poem) }

        it "includes poem in resolved scope" do
          expect(resolved_scope).to include(poem)
        end

        it { should permit_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end

      context "accessing an unpublished poem" do
        let(:poem) { FactoryGirl.create(:unpublished_poem) }

        it "excludes poem from resolved scope" do
          expect(resolved_scope).not_to include(poem)
        end

        it { should forbid_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end
    end

    context "accessing poems the user contributes to" do
      context "accessing a published poem" do
        let(:poem) {
          FactoryGirl.create(
            :published_poem, 
            contributions: [
              Contribution.new(contributor_profile: contributor_profile)
            ]
          )
        }

        it "includes poem in resolved scope" do
          expect(resolved_scope).to include(poem)
        end

        it { should permit_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end

      context "accessing an unpublished poem" do
        let(:poem) {
          FactoryGirl.create(
            :unpublished_poem, 
            contributions: [
              Contribution.new(contributor_profile: contributor_profile)
            ]
          )
        }

        it "includes poem in resolved scope" do
          expect(resolved_scope).to include(poem)
        end

        it { should permit_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end
    end
  end  

  context "being an administrator" do
    let(:user) { FactoryGirl.create(:administrator) }

    context "accessing a published poem" do
      let(:poem) { FactoryGirl.create(:published_poem) }

      it "includes poem in resolved scope" do
        expect(resolved_scope).to include(poem)
      end

      it { should permit_action(:show) }
      it { should permit_new_and_create }
      it { should permit_edit_and_update }
      it { should permit_action(:destroy) }
    end

    context "accessing an unpublished poem" do
      let(:poem) { FactoryGirl.create(:unpublished_poem) }

      it "includes poem in resolved scope" do
        expect(resolved_scope).to include(poem)
      end

      it { should permit_action(:show) }
      it { should permit_new_and_create }
      it { should permit_edit_and_update }
      it { should permit_action(:destroy) }
    end
  end
end
