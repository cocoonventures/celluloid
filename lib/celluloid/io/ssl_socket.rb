require 'openssl'

module Celluloid
  module IO
    # SSLSocket with Celluloid::IO support
    class SSLSocket
      include CommonMethods
      extend Forwardable

      def_delegators :@socket, :read_nonblock, :write_nonblock, :close, :closed?

      def initialize(io, ctx = OpenSSL::SSL::SSLContext.new)
        @ctx = ctx
        @socket = OpenSSL::SSL::SSLSocket.new(::IO.try_convert(io), @ctx)
      end

      def connect
        @socket.connect_nonblock
      rescue ::IO::WaitReadable
        wait_readable
        retry
      end

      def to_io; @socket; end
    end
  end
end
