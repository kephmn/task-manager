# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

alice = User.find_or_create_by!(email: "alice@example.com") { |u| u.password = "password123" }
bob   = User.find_or_create_by!(email: "bob@example.com")   { |u| u.password = "password123" }

project = Project.find_or_create_by!(name: "Website Redesign", owner: alice) do |p|
  p.description = "Revamp the marketing site"
end
project.memberships.find_or_create_by!(user: bob)

project.tasks.find_or_create_by!(title: "Design new homepage") do |t|
  t.assignee = bob
  t.priority = :high
  t.due_date = 2.days.from_now
end

project.tasks.find_or_create_by!(title: "Write copy for pricing page") do |t|
  t.assignee = alice
  t.priority = :medium
  t.due_date = 5.days.from_now
end
