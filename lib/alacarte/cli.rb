require 'thor'
require 'alacarte'

module Alacarte
  class CLI < Thor

    desc "portray ITEM", "Determines if a piece of food is gross or delicious"
    def portray(name)
      puts Alacarte::Waiter.portray(name)
    end

    desc "waiter", "the waiter takes your order, to be stored in config.toml"
    def waiter()
      puts Alacarte::Waiter.takeorder()
    end

  end
end