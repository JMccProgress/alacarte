# frozen_string_literal: true

require_relative "alacarte/version"

require "alacarte/waiter"
require "alacarte/serve"
require "alacarte/status"
require "alacarte/tidy"
require "alacarte/ssh"

module Alacarte
  class Error < StandardError; end
  # Your code goes here...
end