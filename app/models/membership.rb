class Membership < ApplicationRecord
  belongs_to :project
  belongs_to :user

  # Validates that a user can only be a member of a project once
  validates :user_id, uniqueness: { scope: :project_id }
end
