# frozen_string_literal: true

class AppTransaction
  def self.call((ctx, flow_options), **)
    handler_signal = nil # this is the signal we decide to return from Wrap().

    ActiveRecord::Base.transaction do
      signal, (ctx, flow_options) = yield # call the Wrap block

      # It's now up to us to interpret the wrapped activity's outcome.
      terminus_semantic = signal.to_h[:semantic]

      if [ :success, :pass_fast ].include?(terminus_semantic)
        handler_signal = Trailblazer::Activity::Right
      else # something in the wrapped steps went wrong:
        handler_signal = Trailblazer::Activity::Left

        raise ActiveRecord::Rollback # This is the only way to tell ActiveRecord to rollback!
      end
    end # transaction

    return handler_signal, [ ctx, flow_options ]
  end
end
