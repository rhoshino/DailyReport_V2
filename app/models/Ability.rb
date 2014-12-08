# class Ability
#   include CanCan::Ability

#   def initialize(user)

#     user ||= User.new

#     if user.admin?
#       can :manege, :all
#     else
#       can :update, User , :id => user.id
#       can :show, User , :id => user.id
#       can :show, Report , :id => user.id
#       can :update, Report , :id => user.id
#     end
#   end
# end
