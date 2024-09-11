# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can :read, Book
    return unless user.present?

    if user.librarian?
      can :manage, Book
      can :manage, User
      can :return, Borrowing
      can :librarian_dashboard, :dashboard
    elsif user.member?
      can :create, Borrowing
      can :read, Book
      can :member_dashboard, :dashboard
    end
  end
end
