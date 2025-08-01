class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, :all
    elsif user.operator?
      can [ :read, :create ], Policy
    elsif user.client?
      can :read, Policy, user_id: user.id
    end
  end
end
