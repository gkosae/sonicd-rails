class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  module Scopes
    extend ActiveSupport::Concern

    included do
      scope :created_before, lambda { |date|
        date = Time.zone.parse(date.to_s)
        where("#{table_name}.created_at < ?", date)
      }

      scope :updated_before, lambda { |date|
        date = Time.zone.parse(date.to_s)
        where("#{table_name}.updated_at < ?", date)
      }
    end
  end

  include Scopes
end
