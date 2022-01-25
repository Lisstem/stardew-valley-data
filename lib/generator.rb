# frozen_string_literal: true
require 'json'
require 'yaml'
require 'erb'
require 'fileutils'

module StardewValley
  GENERATORS = []

  COMPILER = { 'json' => -> (string, _) { JSON.parse(string) },
               'xnb' => -> (string, _) { JSON.parse(string)},
               'yaml' => ->(string, _) { YAML.load(string) },
               'erb' => ->(string, binding) { ERB.new(string).result(binding).to_s }}

  class Generator
    attr_reader :rb_file, :file

    def initialize(rb_file, file, options, block)
      @rb_file = rb_file
      @file = file
      @block = block
      @basename, *@extensions = File.basename(@file).split('.')
      apply_options(options)
    end

    def execute
      data = load
      data = transform(data) unless @compiler_options[:no_transform]
      save(data)
    end

    def uptodate?
      dependencies = [@rb_file, @file] + Dir.glob(File.join(__dir__, '*.rb')) + @compiler_options[:dependencies]
      if @compiler_options[:target]
        FileUtils.uptodate?(@compiler_options[:target], dependencies)
      else
        FileUtils.uptodate?("#{@basename}.yaml", dependencies) && FileUtils.uptodate?("#{@basename}.json", dependencies)
      end
    end

    private
    COMPILER_KEYS = %i[target keys no_transform dependencies]

    def dependencies=(value)
      value ||= []
      value = [value] unless value && value.respond_to?(:each)
      @compiler_options[:dependencies] = value
    end

    def apply_options(options)
      @options = options.reject { |k, _| COMPILER_KEYS.include? k }
      @compiler_options = options.select { |k, _| COMPILER_KEYS.include? k}
      self.dependencies = @compiler_options[:dependencies]
    end

    def load
      puts "Compiling #{@rb_file}..."
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
        key = @compiler_options[:keys].call(key) if @compiler_options[:keys]
        hash[key] = @block.call(key, value)
        hash
      end
    end

    def save(data)
      if (target = @compiler_options[:target])
        method = case target.split('.')[-1]
                   when 'yaml' then :to_yaml
                   when 'json' then :to_json
                   else :to_s
                 end
        File.write(target, data.public_send(method))
        puts "\t... to #{target}."
      else
        File.write("#{@basename}.yaml", data.to_yaml)
        puts "\t... to #{@basename}.yaml."
        File.write("#{@basename}.json", data.to_json)
        puts "\t... to #{@basename}.json."
      end
    end
  end

  def generator(file, **options, &block)
    caller_file = caller_locations(1, 1).first.path
    GENERATORS << Generator.new(caller_file , file, options, block)
  end

  class << self
    def load_generators
      Dir.glob("#{File.dirname(__FILE__)}/generators/*.rb").sort.each do |path|
        puts "Found generator #{File.basename(path)}." if require_relative path
      end
    end

    def execute_generators
      GENERATORS.each do |generator|
        if generator.uptodate?
          puts "Skipping #{generator.rb_file} (up to date)."
        else
          generator.execute
        end
      end
    end
  end
end
