class ApplicationPolicy < Struct.new(:user, :record)
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

  def user_contributes_to_record?
    if user.contributor_profile.present?
      if record.contributions.where(
        contributor_profile_id: user.contributor_profile_id
      ).count > 0
        return true
      end
    end
  end
end
