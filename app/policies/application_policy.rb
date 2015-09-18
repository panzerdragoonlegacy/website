class ApplicationPolicy < Struct.new(:user, :record)
  def new?
  	user ? user.administrator : false
  end

  def create?
  	user ? user.administrator : false
  end

  def edit?
  	user ? user.administrator : false
  end

  def update?
  	user ? user.administrator : false
  end

  def destroy?
  	user ? user.administrator : false
  end
end
