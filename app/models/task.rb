class Task < ApplicationRecord
  belongs_to :project

  # optional: true allows a task to be unassigned, which is useful for tasks that are not yet assigned to anyone.
  belongs_to :assignee, class_name: "User", optional: true

  # Enum maps integers in the database to human-readable symbols in the code, making it easier to work with task statuses.
  enum status: { not_started: 0, in_progress: 1, completed: 2 }

  validates :title, presence: true
  
  scope :completed, -> { where(status: :completed) }
  scope :active, -> { where.not(status: :completed) }
  scope :overdue, -> { where("due_date < ? AND status != ?", Time.current, statuses[:completed ]) }

  #This is the hook that makes real-time updates work: every time a task is created, updated, or destroyed, it triggers a broadcast to the relevant project channel, which the front-end listens to for live updates.
  broadcasts_to ->(task) { [task.project, "tasks"] }, partial: "tasks/task", target: -> (task) { "task_#{task.id}" }
  
end
