# frozen_string_literal: true

require_relative 'loader'
require_relative 'errors/file_error'
require_relative 'errors/file_extension_error'
require_relative 'errors/ip_error'
require_relative 'errors/path_error'
require_relative 'validators/file'
require_relative 'validators/log_line'
require_relative 'models/log_rec'
require_relative 'processor'
require_relative 'counters/base'
require_relative 'counters/total'
require_relative 'counters/uniq'
require_relative 'printer'

module Parser
  class Runner
    def initialize(file)
      @file = file
    end

    def call
      validate_file

      load_data
      visit_results, unique_results = count

      print_results(visit_results, unique_results)
    end

    private

    def validate_file
      Parser::Validators::File.new(file).validate!
    end

    def load_data
      @load_data ||= Parser::Loader.build(file).call
    end

    def count
      counters.map { |counter| Parser::Processor.run(@load_data, counter) }
    end

    def counters
      [Parser::Counter::Total, Parser::Counter::Uniq]
    end

    def print_results(visit_results, unique_results)
      Parser::Printer.new(visit_results, unique_results).call
    end

    attr_reader :file
  end
end
