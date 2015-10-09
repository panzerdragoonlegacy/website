require 'rails_helper'

describe DownloadPolicy do
  subject { DownloadPolicy.new(user, download) }

  let(:resolved_scope) {
    DownloadPolicy::Scope.new(user, Download.all).resolve
  }

  context "being a visitor" do
    let(:user) { nil }

    context "creating a new download" do
      let(:download) { Download.new }

      it { should forbid_new_and_create }
      it { should forbid_mass_assignment_of(:publish) }
    end

    context "accessing downloads in a published category" do
      context "accessing a published download" do
        let(:download) {
          FactoryGirl.create(:published_download_in_published_category)
        }

        it "includes download in resolved scope" do
          expect(resolved_scope).to include(download)
        end

        it { should permit_action(:show) }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
        it { should forbid_mass_assignment_of(:publish) }
      end

      context "accessing an unpublished download" do
        let(:download) {
          FactoryGirl.create(:unpublished_download_in_published_category)
        }

        it "excludes download from resolved scope" do
          expect(resolved_scope).not_to include(download)
        end

        it { should forbid_action(:show) }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
        it { should forbid_mass_assignment_of(:publish) }
      end
    end
    
    context "accessing downloads in an unpublished category" do
      context "accessing a published download" do
        let(:download) {
          FactoryGirl.create(:published_download_in_unpublished_category)
        }

        it "excludes download from resolved scope" do
          expect(resolved_scope).not_to include(download)
        end

        it { should forbid_action(:show) }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
        it { should forbid_mass_assignment_of(:publish) }
      end

      context "accessing an unpublished download" do
        let(:download) {
          FactoryGirl.create(:unpublished_download_in_unpublished_category)
        }

        it "excludes download from resolved scope" do
          expect(resolved_scope).not_to include(download)
        end

        it { should forbid_action(:show) }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
        it { should forbid_mass_assignment_of(:publish) }
      end
    end
  end

  context "being a registered user" do
    let(:user) { FactoryGirl.create(:registered_user) }

    context "creating a new download" do
      let(:download) { Download.new }

      it { should forbid_new_and_create }
      it { should forbid_mass_assignment_of(:publish) }
    end

    context "accessing downloads in a published category" do
      context "accessing a published download" do
        let(:download) {
          FactoryGirl.create(:published_download_in_published_category)
        }

        it "includes download in resolved scope" do
          expect(resolved_scope).to include(download)
        end

        it { should permit_action(:show) }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
        it { should forbid_mass_assignment_of(:publish) }
      end

      context "accessing an unpublished download" do
        let(:download) {
          FactoryGirl.create(:unpublished_download_in_published_category)
        }

        it "excludes download from resolved scope" do
          expect(resolved_scope).not_to include(download)
        end

        it { should forbid_action(:show) }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
        it { should forbid_mass_assignment_of(:publish) }
      end
    end

    context "accessing downloads in an unpublished category" do
      context "accessing a published download" do
        let(:download) {
          FactoryGirl.create(:published_download_in_unpublished_category)
        }

        it "excludes download from resolved scope" do
          expect(resolved_scope).not_to include(download)
        end

        it { should forbid_action(:show) }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
        it { should forbid_mass_assignment_of(:publish) }
      end

      context "accessing an unpublished download" do
        let(:download) {
          FactoryGirl.create(:unpublished_download_in_unpublished_category)
        }

        it "excludes download from resolved scope" do
          expect(resolved_scope).not_to include(download)
        end

        it { should forbid_action(:show) }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
        it { should forbid_mass_assignment_of(:publish) }
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

    context "creating a new download" do
      let(:download) { Download.new }

      it { should permit_new_and_create }
      it { should forbid_mass_assignment_of(:publish) }
    end

    context "accessing downloads in a published category" do
      context "accessing downloads that the user does not contribute to" do
        context "accessing a published download" do
          let(:download) {
            FactoryGirl.create(:published_download_in_published_category)
          }

          it "includes download in resolved scope" do
            expect(resolved_scope).to include(download)
          end

          it { should permit_action(:show) }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
          it { should forbid_mass_assignment_of(:publish) }
        end

        context "accessing an unpublished download" do
          let(:download) {
            FactoryGirl.create(:unpublished_download_in_published_category)
          }

          it "excludes download from resolved scope" do
            expect(resolved_scope).not_to include(download)
          end

          it { should forbid_action(:show) }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
          it { should forbid_mass_assignment_of(:publish) }
        end
      end

      context "accessing downloads the user contributes to" do
        context "accessing a published download" do
          let(:download) {
            FactoryGirl.create(
              :published_download_in_published_category, 
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          }

          it "includes download in resolved scope" do
            expect(resolved_scope).to include(download)
          end

          it { should permit_action(:show) }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
          it { should forbid_mass_assignment_of(:publish) }
        end

        context "accessing an unpublished download" do
          let(:download) {
            FactoryGirl.create(
              :unpublished_download_in_published_category, 
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          }

          it "includes download in resolved scope" do
            expect(resolved_scope).to include(download)
          end

          it { should permit_action(:show) }
          it { should permit_edit_and_update }
          it { should permit_action(:destroy) }
          it { should forbid_mass_assignment_of(:publish) }
        end
      end
    end

    context "accessing downloads in an unpublished category" do
      context "accessing downloads that the user does not contribute to" do
        context "accessing a published download" do
          let(:download) {
            FactoryGirl.create(:published_download_in_published_category)
          }

          it "includes download in resolved scope" do
            expect(resolved_scope).to include(download)
          end

          it { should permit_action(:show) }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
          it { should forbid_mass_assignment_of(:publish) }
        end

        context "accessing an unpublished download" do
          let(:download) {
            FactoryGirl.create(:unpublished_download_in_published_category) 
          }

          it "excludes download from resolved scope" do
            expect(resolved_scope).not_to include(download)
          end

          it { should forbid_action(:show) }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
          it { should forbid_mass_assignment_of(:publish) }
        end
      end

      context "accessing downloads that the user contributes to" do
        context "accessing a published download" do
          let(:download) {
            FactoryGirl.create(
              :published_download_in_unpublished_category, 
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          }

          it "includes download in resolved scope" do
            expect(resolved_scope).to include(download)
          end

          it { should permit_action(:show) }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
          it { should forbid_mass_assignment_of(:publish) }
        end

        context "accessing an unpublished download" do
          let(:download) {
            FactoryGirl.create(
              :unpublished_download_in_unpublished_category, 
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          }

          it "includes download in resolved scope" do
            expect(resolved_scope).to include(download)
          end

          it { should permit_action(:show) }
          it { should permit_edit_and_update }
          it { should permit_action(:destroy) }
          it { should forbid_mass_assignment_of(:publish) }
        end
      end
    end
  end

  context "being an administrator" do
    let(:user) { FactoryGirl.create(:administrator) }

    context "creating a new download" do
      let(:download) { Download.new }

      it { should permit_new_and_create }
      it { should permit_mass_assignment_of(:publish) }
    end

    context "accessing downloads in a published category" do
      context "accessing a published download" do
        let(:download) {
          FactoryGirl.create(:published_download_in_published_category)
        }

        it "includes download in resolved scope" do
          expect(resolved_scope).to include(download)
        end

        it { should permit_action(:show) }
        it { should permit_edit_and_update }
        it { should permit_action(:destroy) }
        it { should permit_mass_assignment_of(:publish) }
      end

      context "accessing an unpublished download" do
        let(:download) {
          FactoryGirl.create(:unpublished_download_in_published_category)
        }

        it "includes download in resolved scope" do
          expect(resolved_scope).to include(download)
        end

        it { should permit_action(:show) }
        it { should permit_edit_and_update }
        it { should permit_action(:destroy) }
        it { should permit_mass_assignment_of(:publish) }
      end
    end

    context "accessing downloads in an unpublished category" do
      context "accessing a published download" do
        let(:download) {
          FactoryGirl.create(:published_download_in_unpublished_category)
        }

        it "includes download in resolved scope" do
          expect(resolved_scope).to include(download)
        end

        it { should permit_action(:show) }
        it { should permit_edit_and_update }
        it { should permit_action(:destroy) }
        it { should permit_mass_assignment_of(:publish) }
      end

      context "accessing an unpublished download" do
        let(:download) {
          FactoryGirl.create(:unpublished_download_in_unpublished_category)
        }

        it "includes download in resolved scope" do
          expect(resolved_scope).to include(download)
        end

        it { should permit_action(:show) }
        it { should permit_edit_and_update }
        it { should permit_action(:destroy) }
        it { should permit_mass_assignment_of(:publish) }
      end
    end
  end
end
