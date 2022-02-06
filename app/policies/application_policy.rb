class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def new?
    user ? user.administrator? : false
  end

  def create?
    user ? user.administrator? : false
  end

  def edit?
    user ? user.administrator? : false
  end

  def update?
    user ? user.administrator? : false
  end

  def destroy?
    user ? user.administrator? : false
  end

  private

  def can_contribute?
    user && (user.administrator? || user.contributor_profile)
  end

  def user_contributes_to_record?
    user.contributor_profile &&
      record
        .contributions
        .where(contributor_profile_id: user.contributor_profile_id)
        .count > 0
  end
end
