class CarPolicy < ApplicationPolicy
  def edit?
    user.present?
  end
end
