class ApplicationPolicy < Struct.new(:user, :record)
  def new?
  	user ? user.role?(:administrator) : false
  end

  def create?
  	user ? user.role?(:administrator) : false
  end

  def edit?
  	user ? user.role?(:administrator) : false
  end

  def update?
  	user ? user.role?(:administrator) : false
  end

  def destroy?
  	user ? user.role?(:administrator) : false
  end
end
