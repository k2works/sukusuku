module ApplicationHelper
  def title(value)
    unless value.nil?
      @title = "#{value} | MvpSmokeTester"
    end
  end

  def todo_status(todo)
    case todo.status.to_i
    when 0
      '未完了'
    when 1
      '完了'
    when
      ''
    end
  end

  def todo_priority(todo)
    case todo.priority.to_i
    when 1
      '低'
    when 2
      '中'
    when 3
      '高'
    else
      ''
    end
  end
end
