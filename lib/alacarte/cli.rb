require 'thor'
require 'alacarte'

module Alacarte
  class CLI < Thor

    desc "portray ITEM", "Determines if a piece of food is gross or delicious"
    def portray(name)
      puts Alacarte::Waiter.portray(name)
    end

    desc "waiter", "The waiter takes your order, to be stored in config.toml"
    def waiter()
      puts Alacarte::Waiter.take_order()
    end

    desc "serve", "Use me to serve up your order - this makes the necessary terraform/vagrant files, and then fires up the environment"
    def serve()
      puts Alacarte::Serve.make_order()
    end

    desc "status", "Let's see whats going on, run 'status' to see whats running."
    def status()
      puts Alacarte::Status.show()
    end

    desc "tidy", "Are tou all done? use 'tidy' to clean up your existing infrastructure."
    def tidy()
      puts Alacarte::Tidy.clean_up()
    end

    desc "ssh SERVER_NAME", "Get connected to the servers you need, run 'ssh' followed by your specific server name."
    def ssh(server_name)
      puts Alacarte::Ssh.connect_to(server_name)
    end

  end
end