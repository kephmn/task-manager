class Project < ApplicationRecord
  belongs_to :owner, class_name: "User"

  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user

  has_many :tasks, dependent: :destroy
  validates :name, presence: true

  # Runs automatically whenever a project is created — makes the owner
  # a member too, so they show up in the assignee dropdown alongside
  # anyone else invited later, without special-casing "owner OR member"
  # logic everywhere else in the app.
  after_create :add_owner_as_member

  #Handy scope for a project's completion status at a glance, for use in the dashboard and elsewhere.
  def completed_percentage
    return 0 if tasks.none?
    (tasks.completed.count.to_f / tasks.count * 100).round
  end

  private

  def add_owner_as_member
    memberships.create!(user: owner)
  end
end
