class DragoonPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def show?
    true
  end

  def new?
    if user
      user.administrator
    else
      Dragoon.count == 0 ? true : false
    end
  end

  def create?
    if user
      user.administrator
    else
      Dragoon.count == 0 ? true : false
    end
  end
end
