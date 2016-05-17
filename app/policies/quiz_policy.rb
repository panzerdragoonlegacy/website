class QuizPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      if user
        return scope if user.administrator?
        if user.contributor_profile.present?
          return scope.joins(:contributions).where("quizzes.publish = 't' OR " +
            "contributions.contributor_profile_id = ?",
            user.contributor_profile_id)
        end
      end
      scope.where(publish: true)
    end
  end

  def show?
    if user
      return true if user.administrator?
      if user.contributor_profile.present?
        if record.contributions.where(
          contributor_profile_id: user.contributor_profile_id).count > 0
          return true
        end
      end
    end
    record.publish?
  end

  def new?
    if user
      return true if user.administrator? || user.contributor_profile.present?
    end
  end

  def create?
    new?
  end

  def edit?
    if user
      return true if user.administrator?
      if user.contributor_profile.present?
        if !record.publish && record.contributions.where(
          contributor_profile_id: user.contributor_profile_id).count > 0
          return true
        end
      end
    end
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  def permitted_attributes
    permitted_attributes = [
      :name,
      :description,
      quiz_questions_attributes: [
        :content, quiz_answers_attributes: [
          :content, :correct_answer
        ]
      ],
      contributor_profile_ids: [],
      encyclopaedia_entry_ids: []
    ]
    if user
      permitted_attributes << :publish if user.administrator?
    end
    permitted_attributes
  end
end
