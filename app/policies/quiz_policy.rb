class QuizPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user
        return scope if user.administrator?
        return scope_user_contributes_to if user.contributor_profile
      end
      scope.where publish: true
    end

    private

    def scope_user_contributes_to
      scope.joins(:contributions).where(
        'quizzes.publish = true OR contributions.contributor_profile_id = ?',
        user.contributor_profile_id
      )
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
    can_contribute?
  end

  def create?
    new?
  end

  def edit?
    return unless user
    return true if user.administrator?
    return true if user_contributes_to_record? && !record.publish
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  def permitted_attributes
    permitted_attributes = attributes_except_publish
    permitted_attributes << :publish if user&.administrator?
    permitted_attributes
  end

  private

  def attributes_except_publish
    [
      :category_id,
      :name,
      :description,
      quiz_questions_attributes: quiz_questions_attributes,
      contributor_profile_ids: [],
      tag_ids: []
    ]
  end

  def quiz_questions_attributes
    [:content, quiz_answers_attributes: quiz_answers_attributes]
  end

  def quiz_answers_attributes
    %i[content correct_answer]
  end
end
