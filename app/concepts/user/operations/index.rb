# frozen_string_literal: true

module User::Operations
  class Index < ApplicationOperation
    step :load_users

    def load_users(ctx, params:, **)
      ctx[:users] = User.all.ransack(params[:q]).result
    end
  end
end
