class TaskController < ApplicationController
    before_action :set_project
    before_action :set_task, only: %i[update, destroy, toggle]

    def create
        @task = @projecttasks.build(task_params)
        respond_to do |format|
            if @task.save
                # turbo_stream response: instead of a full page redirect,
                # Rails sends back a small instruction ("prepend this HTML
                # to #tasks") that Turbo applies to the DOM directly.
                # The broadcasts_to in the Task model ALSO pushes this same
                # update to every other connected browser viewing this project.
                format.turbo_stream
                format.html { redirect_to @project }
                else
                    format.turbo_stream { render turbo_stream: turbo_stream.replace(@new_task_form, partial: "tasks/form", locals: { project: @project, task: @task }) }
                    format.html { redirect_to @project, alert: "Task could not be created." }
                end
        end
    end

    # Dedicated endpoint for the "mark complete" checkbox — flips status
    # in one click, no form submit, no page reload.
    def toggle
        @task.update(status: @task.completed? ? :pending : :completed)
        respond_to do |format|
            format.turbo_stream
            format.html { redirect_to @project }
        end
    end

    def update
        @task.update(task_params)
        respond_to do |format|
            format.turbo_stream
            format.html { redirect_to @project }
        end

    def destroy
        @task.destroy
        respond_to do |format|
            format.turbo_stream
            format.html { redirect_to @project }
        end
    end

    private

    def set_project
        @project = current_user.projects.find(params[:project_id])
    end

    def set_task
        @task = @project.tasks.find(params[:id])
    end

    def task_params
        params.require(:task).permit(:title, :description, :due_date, :priority, :assignee_id)
    end
end