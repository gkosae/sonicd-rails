class Task < ApplicationRecord
  include MultiState

  state :queued,      field: :status, initial: true
  state :in_progress, field: :status
  state :completed,   field: :status
  state :failed,      field: :status
end
