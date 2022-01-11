#!/usr/bin/ruby


require 'toml'
require 'thor'


module Alacarte


    class Waiter
      
        def self.portray(food)
            if food.downcase == "broccoli"
            "Gross!"
            else
            "Delicious!"
            end
        end

        def self.welcome()
            "Welcome to Alacarte, Please may I take your order?"
        end

        def self.menu_question()
            "If you know the menu item you want then please enter 1,2 or 3, or to see the full menu enter m or menu."
        end

        def self.fullmenu()
            "On todays menu is;
1) Basic Infra and Automate

               ┌─────────────────┐
┌──────────────┤Chef Workstation ├────────────┐
│              └─────────────────┘            │
│                                             │
│ ┌───────┐──►   ┌──────────┐    ┌──────────┐ │
│ │┌───────┐──►  │Chef Infra│    │Automate 2│ │
│ └┤┌───────┐──► │  Server  ├───►│  Server  │ │
│  └┤ Nodes │    └──────────┘    └──────────┘ │
│   └───────┘                          ▲      │
│                       ┌───────────┐  │      │
│                       │  Habitat  │  │      │
│                       │Environment├──┘      │
│                       │ (optional)│         │
│                       └───────────┘         │
│                                             │
└─────────────────────────────────────────────┘

2) Automate combined Infra

               ┌─────────────────┐
┌──────────────┤Chef Workstation ├──────┐
│              └─────────────────┘      │
│                                       │
│                 ┌───────────────────┐ │
│                 │                   │ │
│ ┌───────┐──►    │ Automate 2 Server │ │
│ │┌───────┐──►   │                   │ │
│ └┤┌───────┐──►  ├────────────┐      │ │
│  └┤ Nodes │     │Chef  Infra │      │ │
│   └───────┘     │   Server   │      │ │
│                 └────────────┴──────┘ │
│    ┌───────────┐               ▲      │
│    │  Habitat  │               │      │
│    │Environment├───────────────┘      │
│    │ (optional)│                      │
│    └───────────┘                      │
│                                       │
└───────────────────────────────────────┘

3) Infra FE and BE with Automate

               ┌─────────────────┐
┌──────────────┤Chef Workstation ├─────────────┐
│              └─────────────────┘             │
│                                              │
│ ┌───────┐──►    ┌──────────┐   ┌──────────┐  │
│ │┌───────┐──►   │Chef Infra│   │Automate 2│  │
│ └┤┌───────┐──►  │Server FE ├──►│  Server  │  │
│  └┤ Nodes │     └───┬──────┘   └──────────┘  │
│   └───────┘         │ ▲              ▲       │
│                     ▼ │              │       │
│                 ┌─────┴────┐   ┌─────┴─────┐ │
│                ┌│Chef Infra│   │ Habitat   │ │
│               ┌││Server BE │   │Environment│ │
│               ││└──────────┘   │(optional) │ │
│               │└──────────┘    └───────────┘ │
│               └──────────┘                   │
│                                              │
└──────────────────────────────────────────────┘

(default: 1)"
        end

        def self.menu_item_valid()
            return ["1","2","3"]
        end

        def self.server_type_question()
            "What server type would you like... RHEL, Centos, perhaps Ubuntu? (default: Centos)"
        end

        def self.server_type_valid()
            return ["RHEL","Centos","Ubuntu"]
        end

        def self.server_version_question(serv_type = "")
            
            if serv_type == "RHEL" or  serv_type == "Centos"
                "What #{serv_type} server version would you like...? (default: 8)"
            elsif serv_type == "Ubuntu" 
                "What #{serv_type} server version would you like...? (default: 18.04)"
            end
        end

        def self.server_version_valid(serv_type = "")
            
            if serv_type == "RHEL"
                return ["8.5","8.4","8.3","8.2","8.1","8.0","8","7","6"]
            end

            if serv_type == "Centos"
                return ["8.5","8.4","8.3","8.2","8.1","8.0","8","7","6"]
            end

            if serv_type == "Ubuntu"
                return ["20.04","18.04","16.04"]
            end

            return ["1"]

        end

        def self.automate_version_question()
            "What automate version would you like...? (default: Latest)"
        end

        def self.automate_version_valid(auto_vers = "0")
            
            auto_vers = auto_vers.to_s

            if auto_vers.downcase == "latest"
                return true
            elsif auto_vers.match(/20\d{12}/)
                return true
            else
                return false
            end

        end

        def self.infra_server_version_question()
            "Which Infra Server version do you need...? (default: Latest)"
        end

        def self.infra_server_version_valid(infra_vers)

            self.is_semantic(infra_vers)

        end

        def self.number_or_nil(string)
            Integer(string || '')
        rescue ArgumentError
            nil
        end
        
        def self.node_count_question()
            "How many nodes would you like...? (default: 0)"
        end

        def self.node_count_valid(node_count = "X")
            
            node_count = self.number_or_nil(node_count)
            
            if node_count == nil
                return false
            end

            if node_count >= 0 and node_count < 5
                return true
            elsif node_count > 5
                puts " - It is recommended not to exceed 5 nodes on a test setup,"
                puts " - If you need to test load, please review the load test tool"
                puts " - Are you sure you want to contine with #{node_count} nodes? (y/n)"

                response = self.ask("Yes/No: ")

                if response.downcase.include?"y"
                    return true
                else
                    return false
                end
            else 
                return false
            end

        end

        def self.node_version_question()
            "What version of chef-client for the nodes...? (default: Latest)"
        end

        def self.node_version_valid(node_vers = "X")

            self.is_semantic(node_vers)

        end

        def self.habitat_required_question()
            "Would you like a side of habitat with that...? (default: no)"
        end

        def self.habitat_required_valid(response)

            response = response.to_s

            response == "yes" or response == "no" 

        end

        def self.is_semantic(version)
            
            version = version.to_s

            if version.downcase == "latest"
                return true
            elsif version.match(/\A\d+\.\d+\.\d+\z|\A\d+\.\d+\z|\A\d+\z/)
                return true
            else
                return false
            end

        end

        def self.habitat_version_question()
            "and what version of habitat is that...? (default: Latest)"
        end

        def self.habitat_version_valid(hab_vers)

            self.is_semantic(hab_vers)

        end

        def self.menu_to_config(number)

            case number
            when "1"
                "Basic Infra and Automate"
            when "2"
                "Automate combined Infra"
            when "3"
                "Infra FE and BE with Automate"
            end

        end

        def self.generate_config_toml(ord_data)

            puts ord_data

            puts "--------------"

            hash = Hash.new()

            hash = {
                "order" => {

                    "menu_order_num" => ord_data["menu_item"],
                    "menu_config_type" => self.menu_to_config(ord_data["menu_item"]),

                    "server" => {
                        "type" => ord_data["server_type"],
                        "version" => ord_data["server_version"]
                    },
                    "automate" => {
                        "version" => ord_data["automate_version"],
                        "server" => "#{ord_data["server_type"]}/#{ord_data["server_version"]}"
                    },
                    "nodes" => {
                        "count" => ord_data["node_count"],
                        "version" => ord_data["node_version"],
                        "server" => "#{ord_data["server_type"]}/#{ord_data["server_version"]}"
                    },
                    "infa_server" => {
                        "version" => ord_data["infra_server_version"],
                        "server" => "#{ord_data["server_type"]}/#{ord_data["server_version"]}"
                    },
                    "habitat" => {
                        "required" => ord_data["habitat_required"].downcase,
                        "version" => ord_data["habitat_version"],
                        "server" => "#{ord_data["server_type"]}/#{ord_data["server_version"]}"
                    },
                    "location" => {
                        "is_at" => ord_data["location"],
                        "version" => ord_data["location_version"],

                    },
                    

                }

            }
            doc = TOML::Generator.new(hash).body
            # doc will be a string containing a proper TOML document.

            puts doc

            File.open("./config.toml", 'w') { |file| file.write(doc) }

        end

        def self.shell
            @shell ||= Thor::Shell::Basic.new
        end

        def self.ask(question)
            
            self.shell.ask(question)

        end
        
        def self.take_order()

            order_data = Hash.new
            
            puts self.welcome

            puts self.menu_question

            order_data["menu_item"] = self.ask("Menu item number:")

            puts order_data["menu_item"]

            while (order_data["menu_item"].downcase.include?"m") or !(self.menu_item_valid).include?(order_data["menu_item"])

                puts self.fullmenu

                order_data["menu_item"] = puts self.menu_question

                order_data["menu_item"] = self.ask("Menu item number:")

                if order_data["menu_item"] == ""
                    order_data["menu_item"] = "1"
                end
            
            end

            while !(self.server_type_valid).include?(order_data["server_type"])
                
                puts self.server_type_question

                order_data["server_type"] = self.ask("Server type:")

                if order_data["server_type"] == ""
                    order_data["server_type"] = "Centos"
                end
            end

            while !(self.server_version_valid(order_data["server_type"])).include?(order_data["server_version"])
                
                puts self.server_version_question(order_data["server_type"])

                order_data["server_version"] = self.ask("Server version:")

                if order_data["server_version"] == "" and (order_data["server_type"] == "RHEL" or order_data["server_type"] == "Centos")
                    order_data["server_version"] = "8"
                elsif order_data["server_version"] == "" and order_data["server_type"] == "Ubuntu"
                    order_data["server_version"] = "18.04"
                end

            end

            while !(self.automate_version_valid(order_data["automate_version"]))
                
                puts self.automate_version_question

                order_data["automate_version"] = self.ask("Automate version:")
                
                if order_data["automate_version"] == ""
                    order_data["automate_version"] = "Latest"
                end


            end

            while !(self.infra_server_version_valid(order_data["infra_server_version"]))
                
                puts self.infra_server_version_question

                order_data["infra_server_version"] = self.ask("Infra server version:")
                
                if order_data["infra_server_version"] == ""
                    order_data["infra_server_version"] = "Latest"
                end


            end
            
            while !(self.node_count_valid(order_data["node_count"]))
                
                puts self.node_count_question

                order_data["node_count"] = self.ask("Number of nodes:")

                if order_data["node_count"] == ""
                    order_data["node_count"] = "0"
                end

            end

            while !(self.node_version_valid(order_data["node_version"]))
                
                puts self.node_version_question

                order_data["node_version"] = self.ask("Node infra version:")

                if order_data["node_version"] == ""
                    order_data["node_version"] = "Latest"
                end

            end

            while !(self.habitat_required_valid(order_data["habitat_required"]))
                
                puts self.habitat_required_question

                order_data["habitat_required"] = self.ask("Habitat, yes or no:")

                if order_data["habitat_required"] == ""
                    order_data["habitat_required"] = "no"
                end

            end

            if order_data["habitat_required"] == "yes"
                while !(self.habitat_version_valid(order_data["habitat_version"]))
                
                    puts self.habitat_version_question
    
                    order_data["habitat_version"] = self.ask("Which Habitat version:")

                    if order_data["habitat_version"] == ""
                        order_data["habitat_version"] = "Latest"
                    end
    
                end
            end

            self.generate_config_toml(order_data)

        end

    end
end

