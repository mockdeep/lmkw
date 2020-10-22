# frozen_string_literal: true

session_config = { key: "_let_me_know_when_session", max_age: 1.month }
Rails.application.config.session_store(:cookie_store, **session_config)
