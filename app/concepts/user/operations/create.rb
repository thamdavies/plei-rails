# frozen_string_literal: true

module User::Operations
  class Create < ApplicationOperation
    class Present < ApplicationOperation
      step Model(User, :new)
      step Contract::Build(constant: User::Contracts::Create)
    end

    step Subprocess(Present)
    step Contract::Validate()
    step Contract::Persist()
  end
end
