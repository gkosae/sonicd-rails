module MultiState
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def state_field(_state_field = nil)
      get_or_set_state_field(_state_field)
    end

    def states_for(_field)
      _field = _field.to_s
      states.select{ |entry| entry[:field] == _field }.map{ |entry| entry[:state] }
    end

    def states
      @states || []
    end
    
    def state(
      _state,
      field: nil,
      initial: false,
      after_transition: nil
    )
      _state = _state.to_s
      field ||= state_field
      field = field.to_s
      @states ||= []

      return unless @states.select{ |entry| 
        entry[:field] == field && 
        entry[:state] == _state
      }.empty?
      

      @states << { field: field, state: _state, after_transition: after_transition }
      code = <<~CODE.strip
        scope :#{_state}, ->{ where(#{field}: "#{_state}") }

        #{"before_create ->(record){ record.#{field} ||= '#{_state}' }" if initial}

        def #{_state}
          return if #{_state}?
          
          state_entry = self.class.states.select{ |entry| 
            entry[:field] == '#{field}' && 
            entry[:state] == '#{_state}'
          }.first

          update(#{field}: "#{_state}")
          #{"state_entry[:after_transition].call(self)" if after_transition.respond_to?(:call)}
        end

        def #{_state}?
          #{field} == "#{_state}"
        end
      CODE

      class_eval(code)
    end

    private
    def get_or_set_state_field(_state_field_or_nil)
      if _state_field_or_nil.nil?
        return @state_field
      end

      @state_field = _state_field_or_nil.to_s
    end
  end
end