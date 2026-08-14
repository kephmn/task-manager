class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Projects that the user owns/created 
  has_many :owned_projects, class_name: "Project", foreign_key: :owner_id, dependent: :destroy

  # Projects this user is a member/collaborator on (via the join model),
  # separate from ownership — an owner is automatically a member too,
  # handled when a project is created (see Project#add_owner_as_member below)
  has_many :memberships, dependent: :destroy
  has_many :projects, through: :memberships

  # Tasks assigned to this user, accross any project
  has_many :assigned_tasks, class_name: "Task", foreign_key: :assigned_id, dependent: :nullify
end
