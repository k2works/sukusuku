class ManageController < ApplicationController
  before_action :set_todo, only: [:show, :edit, :update, :destroy]
  before_action :priority_values, only: [:new, :edit]

  # GET /todos
  # GET /todos.json
  def index
    @todos = Todo.incomplete
  end

  def finished
    @todos = Todo.complete
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @todo.update(todo_params)
        format.html { redirect_to manage_path(@todo), notice: 'Todo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_todo
    @todo = Todo.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def todo_params
    params.require(:todo).permit(:title, :contents, :due, :priority, :status)
  end
end
