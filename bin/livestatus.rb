require 'socket'
require 'visioner/notifications'
require 'visioner/validation'

module Visioner; module Util

  class Livestatus

    include Visioner::Validation

    attr_accessor :logger, :server, :port, :timeout

    def initialize(options)
      require_non_empty(options[:server], "no server specified")
      @logger = Visioner::NotificationInstance.logger
      @server = options[:server]
      @port = options[:port] || 6557
      @timeout = options[:timeout] || 10
    end

    def run_query query
      result = nil
      Timeout.timeout(timeout) do
        begin
          s = TCPSocket.new(server, port)
          # we need an extra <NL> to tell livestatus to run the query
          logger.trace "Running livestatus query #{query.inspect} against #{server}:#{port}"
          s.puts query, ''
          result = s.read
          logger.trace "Got response: #{result.inspect}"
          s.close
        rescue => e
          logger.error "Error running query against livestatus: #{e.message}"
        end
      end
      return result
    end

    def critical_services host
      result = run_query(
        ['GET services',
         'Columns: description plugin_output',
         'Filter: state = 2',
         "Filter: host_name = #{host}"].join("\n"))
      # return [ [service description, plugin output] ]
      result.split("\n").map {|row| row.split(';')}
    end

    def all_ok? hostname
      result = run_query(
        ['GET services',
         'Stats: state = 0',
         'Stats: state = 2',
         "Filter: host_name = #{hostname}"].join("\n"))
      return false if result.nil?
      (ok, crit) = result.strip.split(';')
      logger.debug "Found #{ok} OK services and #{crit} CRITICAL services for #{hostname}"
      return ( (ok.to_i > 0) and (crit.to_i == 0) )
    end

    def up? hostname
      result = run_query(
        ['GET hosts',
         'Columns: hard_state',
         "Filter: name = #{hostname}"].join("\n"))
      return false if result.nil?
      return (result.to_i == 0)
    end

    def exists? hostname
      result = run_query(
        ['GET hosts',
         'Columns: name',
         "Filter: name = #{hostname}"].join("\n"))
      return (not result.nil?)
    end

    def down? hostname
      not up? hostname
    end

  end

end; end
