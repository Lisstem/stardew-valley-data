# frozen_string_literal: true
require 'json'
require 'yaml'
require 'erb'

module StardewValley
  GENERATORS = []

  COMPILER = { 'json' => -> (string, _) { JSON.parse(string) },
               'xnb' => -> (string, _) { JSON.parse(string)},
               'yaml' => ->(string, _) { YAML.load(string) },
               'erb' => ->(string, binding) { ERB.new(string).result(binding).to_s }}

  class Generator
    def initialize(file, options, block)
      @file = file
      @options = options.reject { |k, _| %i[target keys].include? k }
      @target = options[:target]
      @keys = options[:keys]
      @block = block
      @basename, *@extensions = File.basename(@file).split('.')
    end

    def execute
      save(transform(load))
    end

    private

    def load
      puts "Compiling #{@file}..."
      @extensions.reverse.reduce(File.read(@file)) { | data, ext | COMPILER[ext]&.call(data, @block.binding ) || data }
    end

    def transform(data)
      data = data['data'] if data.respond_to?(:keys) && data.keys == ['data']
      result = @options.dup
      result['data'] = if data.respond_to? :each_pair
                         transform_hash(data)
                       else
                         transform_array(data)
                       end
      result
    end

    def transform_array(data)
      data.map! { |e| @block.call(e) }
    end

    def transform_hash(data)
      data.reduce({}) do |hash, entry|
        key, value = entry
        key = @keys.call(key) if @keys
        hash[key] = @block.call(key, value)
        hash
      end
    end

    def save(data)
      if @target
        method = case @target.split('.')[-1]
                   when 'yaml' then :to_yaml
                   when 'json' then :to_json
                   else :to_s
                 end
        File.write(@target, data.public_send(method))
        puts "\t... to #{@target}."
      else
        File.write("#{@basename}.yaml", data.to_yaml)
        puts "\t... to #{@basename}.yaml."
        File.write("#{@basename}.json", data.to_json)
        puts "\t... to #{@basename}.json."
      end
    end
  end

  class << self
    def generator(file, **options, &block)
        GENERATORS << Generator.new(file, options, block)
    end

    def load_generators
      Dir.glob("#{File.dirname(__FILE__)}/generators/*.rb").sort.each do |path|
        puts "Found generator #{File.basename(path)}." if require_relative path
      end
    end

    def execute_generators
      GENERATORS.each(&:execute)
    end
  end
end
