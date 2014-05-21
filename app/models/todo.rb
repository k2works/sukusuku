class Todo < ActiveRecord::Base
  before_create :default_status

  scope :incomplete, -> { where(status: "0") }
  scope :complete,   -> { where(status: "1") }

  def priority
    read_attribute(:priority) || 2
  end

  private
  def default_status
    self.status = 0
  end
end
