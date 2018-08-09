# frozen_string_literal: true

module CobAlma
  module Requests
    def self.determine_campus(item)
      case item
      when "MAIN", "LAW", "MEDIA", "PRESSER"
        :MAIN
      when "AMBLER"
        :AMBLER
      when "GINSBURG"
        :HSL
      when "PODIATRY"
        :PODIATRY
      when "HARRISBURG"
        :HARRISBURG
      else
        :OTHER
      end
    end

    def self.possible_pickup_locations
      #Make an array on only items that can request items
      ["MAIN", "MEDIA", "AMBLER", "GINSBURG", "PODIATRY", "HARRISBURG"]
    end

    def self.remove_by_campus(campus)
      case campus
      when :MAIN
        ["MAIN", "LAW", "MEDIA", "PRESSER"]
      when :AMBLER
        ["AMBLER"]
      when :HSL
        ["GINSBURG"]
      when :PODIATRY
        ["PODIATRY"]
      when :HARRISBURG
        ["HARRISBURG"]
      when :OTHER
        []
      end
    end

    def self.avail_locations(items_list)
      avail_locations = items_list.map { |k, v|
        if v.any?(&:in_place?)
          return k
        end
      }
      avail_locations
    end

    def self.valid_pickup_locations(items_list)
      pickup_locations = self.possible_pickup_locations
      libraries = self.avail_locations(items_list).split(",")
      if libraries.any?
        libraries.each do |lib|
          campus = self.determine_campus(lib)
          pickup_locations -= remove_by_campus(campus)
        end
      end
      pickup_locations
    end

    def self.equipment(items_list)
      items_list.each do |item|
        if item.circulation_policy == "Equipment"
          pickup_locations = [item.library, item.library_name]
        end
        pickup_locations
      end
    end

    def self.descriptions(items_list)
      descriptions = items_list.map { |item| item["item_data"]["description"] }

      if descriptions.any?
        descriptions.each do |desc|
          desc
        end
      end
      descriptions
    end

    def self.booking_location(items_list)
      pickup_library = items_list.map { |item| [item.library, item.library_name] }
      pickup_library.uniq
    end

    def self.physical_material_type(items_list)
      material_types = items_list.map { |item| item["item_data"]["physical_material_type"] }

      if material_types.any?
        material_types.each do |material|
          material
        end
      end
      material_types.uniq
    end

    def self.item_holding_id(items_list)
      holding_id = items_list.map { |item| item["holding_data"]["holding_id"] }
      holding_id.first
    end

    def self.item_pid(items_list)
      item_pid = items_list.map { |item| item["item_data"]["pid"] }
      item_pid.last
    end
  end
end