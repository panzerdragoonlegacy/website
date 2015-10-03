require 'rails_helper'

describe PicturePolicy do
  subject { PicturePolicy.new(user, picture) }

  let(:resolved_scope) {
    PicturePolicy::Scope.new(user, Picture.all).resolve
  }

  context "being a visitor" do
    let(:user) { nil }

    context "accessing pictures in a published category" do
      context "accessing a published picture" do
        let(:picture) {
          FactoryGirl.create(:published_picture_in_published_category)
        }

        it "includes picture in resolved scope" do
          expect(resolved_scope).to include(picture)
        end

        it { should permit_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end

      context "accessing an unpublished picture" do
        let(:picture) {
          FactoryGirl.create(:unpublished_picture_in_published_category)
        }

        it "excludes picture from resolved scope" do
          expect(resolved_scope).not_to include(picture)
        end

        it { should forbid_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end
    end
    
    context "accessing pictures in an unpublished category" do
      context "accessing a published picture" do
        let(:picture) {
          FactoryGirl.create(:published_picture_in_unpublished_category)
        }

        it "excludes picture from resolved scope" do
          expect(resolved_scope).not_to include(picture)
        end

        it { should forbid_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end

      context "accessing an unpublished picture" do
        let(:picture) {
          FactoryGirl.create(:unpublished_picture_in_unpublished_category)
        }

        it "excludes picture from resolved scope" do
          expect(resolved_scope).not_to include(picture)
        end

        it { should forbid_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end
    end
  end

  context "being a registered user" do
    let(:user) { FactoryGirl.create(:registered_user) }

    context "accessing pictures in a published category" do
      context "accessing a published picture" do
        let(:picture) {
          FactoryGirl.create(:published_picture_in_published_category)
        }

        it "includes picture in resolved scope" do
          expect(resolved_scope).to include(picture)
        end

        it { should permit_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end

      context "accessing an unpublished picture" do
        let(:picture) {
          FactoryGirl.create(:unpublished_picture_in_published_category)
        }

        it "excludes picture from resolved scope" do
          expect(resolved_scope).not_to include(picture)
        end

        it { should forbid_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end
    end

    context "accessing pictures in an unpublished category" do
      context "accessing a published music rack" do
        let(:picture) {
          FactoryGirl.create(:published_picture_in_unpublished_category)
        }

        it "excludes picture from resolved scope" do
          expect(resolved_scope).not_to include(picture)
        end

        it { should forbid_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end

      context "accessing an unpublished picture" do
        let(:picture) {
          FactoryGirl.create(:unpublished_picture_in_unpublished_category)
        }

        it "excludes picture from resolved scope" do
          expect(resolved_scope).not_to include(picture)
        end

        it { should forbid_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end
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

    context "accessing pictures in a published category" do
      context "accessing pictures that the user does not contribute to" do
        context "accessing a published picture" do
          let(:picture) {
            FactoryGirl.create(:published_picture_in_published_category)
          }

          it "includes picture in resolved scope" do
            expect(resolved_scope).to include(picture)
          end

          it { should permit_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end

        context "accessing an unpublished picture" do
          let(:picture) {
            FactoryGirl.create(:unpublished_picture_in_published_category)
          }

          it "excludes picture from resolved scope" do
            expect(resolved_scope).not_to include(picture)
          end

          it { should forbid_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end
      end

      context "accessing pictures the user contributes to" do
        context "accessing a published picture" do
          let(:picture) {
            FactoryGirl.create(
              :published_picture_in_published_category, 
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          }

          it "includes picture in resolved scope" do
            expect(resolved_scope).to include(picture)
          end

          it { should permit_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end

        context "accessing an unpublished picture" do
          let(:picture) {
            FactoryGirl.create(
              :unpublished_picture_in_published_category, 
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          }

          it "includes picture in resolved scope" do
            expect(resolved_scope).to include(picture)
          end

          it { should permit_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end
      end
    end

    context "accessing pictures in an unpublished category" do
      context "accessing pictures that the user does not contribute to" do
        context "accessing a published picture" do
          let(:picture) {
            FactoryGirl.create(:published_picture_in_published_category)
          }

          it "includes picture in resolved scope" do
            expect(resolved_scope).to include(picture)
          end

          it { should permit_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end

        context "accessing an unpublished picture" do
          let(:picture) {
            FactoryGirl.create(:unpublished_picture_in_published_category) 
          }

          it "excludes picture from resolved scope" do
            expect(resolved_scope).not_to include(picture)
          end

          it { should forbid_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end
      end

      context "accessing pictures that the user contributes to" do
        context "accessing an published picture" do
          let(:picture) {
            FactoryGirl.create(
              :published_picture_in_unpublished_category, 
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          }

          it "includes picture in resolved scope" do
            expect(resolved_scope).to include(picture)
          end

          it { should permit_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end

        context "accessing an unpublished picture" do
          let(:picture) {
            FactoryGirl.create(
              :unpublished_picture_in_unpublished_category, 
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          }

          it "includes picture in resolved scope" do
            expect(resolved_scope).to include(picture)
          end

          it { should permit_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end
      end
    end
  end

  context "being an administrator" do
    let(:user) { FactoryGirl.create(:administrator) }

    context "accessing pictures in a published category" do
      context "accessing a published picture" do
        let(:picture) {
          FactoryGirl.create(:published_picture_in_published_category)
        }

        it "includes picture in resolved scope" do
          expect(resolved_scope).to include(picture)
        end

        it { should permit_action(:show) }
        it { should permit_new_and_create }
        it { should permit_edit_and_update }
        it { should permit_action(:destroy) }
      end

      context "accessing an unpublished picture" do
        let(:picture) {
          FactoryGirl.create(:unpublished_picture_in_published_category)
        }

        it "includes picture in resolved scope" do
          expect(resolved_scope).to include(picture)
        end

        it { should permit_action(:show) }
        it { should permit_new_and_create }
        it { should permit_edit_and_update }
        it { should permit_action(:destroy) }
      end
    end

    context "accessing pictures in an unpublished category" do
      context "accessing a published picture" do
        let(:picture) {
          FactoryGirl.create(:published_picture_in_unpublished_category)
        }

        it "includes picture in resolved scope" do
          expect(resolved_scope).to include(picture)
        end

        it { should permit_action(:show) }
        it { should permit_new_and_create }
        it { should permit_edit_and_update }
        it { should permit_action(:destroy) }
      end

      context "accessing an unpublished picture" do
        let(:picture) {
          FactoryGirl.create(:unpublished_picture_in_unpublished_category)
        }

        it "includes picture in resolved scope" do
          expect(resolved_scope).to include(picture)
        end

        it { should permit_action(:show) }
        it { should permit_new_and_create }
        it { should permit_edit_and_update }
        it { should permit_action(:destroy) }
      end
    end
  end
end
