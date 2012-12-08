class Ability  
  include CanCan::Ability  
  
  def initialize(dragoon) 
    dragoon ||= Dragoon.new # Creates guest dragoon if not logged in.
    if dragoon.role? :administrator
      can :manage, :all
    else
      if dragoon.role? :registered
        can :update, Dragoon do |dragoon|
          dragoon.try(:id) == dragoon.id
        end
        can :create, Discussion
        can :update, Discussion do |discussion|
          discussion.try(:dragoon) == dragoon
        end
        can :create, Comment
        can :update, Comment do |comment|
          comment.try(:dragoon) == dragoon
        end
        can :read, Project do |project|
          project.dragoons.include? dragoon
        end
        can :create, ProjectDiscussion do |project_discussion|
          project_discussion.project.dragoons.include? dragoon  
        end
        can :update, ProjectDiscussion do |project_discussion|
          project_discussion.try(:dragoon) == dragoon
        end
        can :read, PrivateDiscussion do |private_discussion|
          private_discussion.dragoons.include? dragoon
        end
        can :create, PrivateDiscussionComment do |private_discussion_comment|
          private_discussion_comment.private_discussion.dragoons.include? dragoon
        end
        can :update, PrivateDiscussionComment do |private_discussion_comment|
          private_discussion_comment.try(:dragoon) == dragoon
        end
      else
        can :create, Dragoon
      end
      can :read, Article, :publish => true, :category => { :publish => true }
      can :read, Category, :publish => true
      can :read, Chapter, :publish => true, :story => { :publish => true }
      can :read, Comment
      can :read, Discussion
      can :read, Download, :publish => true, :category => { :publish => true }
      can :read, Dragoon
      can :read, EncyclopaediaEntry, :publish => true, :category => { :publish => true }
      can :read, Forum
      can :read, GuestbookEntry
      can :read, Link
      can :read, MusicTrack, :publish => true, :category => { :publish => true }
      can :read, NewsEntry, :publish => true
      can :read, Page, :publish => true
      can :read, Picture, :publish => true, :category => { :publish => true }
      can :read, Poem, :publish => true
      can :read, Quiz, :publish => true
      can :read, Resource, :publish => true, :category => { :publish => true }
      can :read, Story, :publish => true, :category => { :publish => true }
      can :read, Video, :publish => true, :category => { :publish => true }
      can :create, GuestbookEntry
    end
  end
end