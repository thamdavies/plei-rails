Clearance.configure do |config|
  config.routes = false
  config.mailer_sender = ENV.fetch("CLEARANCE_MAILER_SENDER", "no-reply@plei.dev")
  config.rotate_csrf_on_sign_in = true
end
