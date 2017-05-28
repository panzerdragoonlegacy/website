class QuizPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      if user
        return scope if user.administrator?
        if user.contributor_profile.present?
          return scope.joins(:contributions).where(
            "quizzes.publish = 't' OR " \
              "contributions.contributor_profile_id = ?",
            user.contributor_profile_id
          )
        end
      end
      scope.where(publish: true)
    end
  end

  def show?
    if user
      return true if user.administrator?
      return true if user_contributes_to_record?
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
      return true if user_contributes_to_record? && !record.publish
    end
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  def permitted_attributes
    permitted_attributes = quiz_attributes
    permitted_attributes << :publish if user && user.administrator?
    permitted_attributes
  end

  private

  def quiz_attributes
    [
      :name,
      :description,
      quiz_questions_attributes: quiz_questions_attributes,
      contributor_profile_ids: [],
      encyclopaedia_entry_ids: []
    ]
  end

  def quiz_questions_attributes
    [:content, quiz_answers_attributes: quiz_answers_attributes]
  end

  def quiz_answers_attributes
    [:content, :correct_answer]
  end
end
