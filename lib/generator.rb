# frozen_string_literal: true
require 'json'
require 'yaml'

module StardewValley
  GENERATORS = []

  class Generator
    def initialize(file, options, block)
      @file = file
      @options = options
      @block = block
    end

    def execute
      save(read)
    end

    private

    def read
      json_data = StardewValley::read_json("raw/#{@file}")
      result = @options.dup
      result['data'] = json_data.reduce({}) do |hash, entry|
        key, value = entry
        hash[key] = @block.call(key, value)
        hash
      end
      result
    end

    def save(data)
      basename = File.basename(@file).split('.')[0...-1].join('.')
      File.write("#{basename}.yaml", data.to_yaml)
      File.write("#{basename}.json", data.to_json)
    end
  end

  class << self

    def generator(file, **options, &block)
        GENERATORS << Generator.new(file, options, block)
    end

    def load_generators
      Dir.glob("#{File.dirname(__FILE__)}/generators/*.rb").each do |path|
        require_relative path
      end
    end

    def execute_generators
      GENERATORS.each(&:execute)
    end
  end
end
