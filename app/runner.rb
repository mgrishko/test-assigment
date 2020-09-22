# frozen_string_literal: true

require_relative 'loader'
require_relative 'errors/file_error'
require_relative 'errors/file_extension_error'
require_relative 'errors/ip_error'
require_relative 'errors/path_error'
require_relative 'validators/file'
require_relative 'validators/log_line'
require_relative 'models/log_rec'
require_relative 'counter'
require_relative 'printer'

module Parser
  class Runner
    def initialize(file)
      @file = file
    end

    def call
      Parser::Validators::File.new(file).valid?

      data = Parser::Loader.new(file).call
      visit_results = Parser::Counter.new(data).count_all
      unique_results = Parser::Counter.new(data).count_uniq

      Parser::Printer.new(visit_results, unique_results).call
    end

    private

    attr_reader :file
  end
end
