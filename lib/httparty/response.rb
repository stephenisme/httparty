module HTTParty
  class Response < HTTParty::BasicObject #:nodoc:
    class Headers
      include Net::HTTPHeader

      def initialize(header)
        @header = header
      end

      def ==(other)
        @header == other
      end

      def inspect
        @header.inspect
      end

      def method_missing(name, *args, &block)
        if @header.respond_to?(name)
          @header.send(name, *args, &block)
        else
          super
        end
      end

      def respond_to?(method)
        super || @header.respond_to?(method)
      end
    end

    attr_reader :response, :parsed_response, :body, :headers

    def initialize(response, parsed_response)
      @response = response
      @body = response.body
      @parsed_response = parsed_response
      @headers = Headers.new(response.to_hash)
    end

    def class
      Object.instance_method(:class).bind(self).call
    end

    def code
      response.code.to_i
    end

    def inspect
      %(<#{self.class} @response=#{response.inspect}>)
    end

    def method_missing(name, *args, &block)
      if parsed_response.respond_to?(name)
        parsed_response.send(name, *args, &block)
      elsif response.respond_to?(name)
        response.send(name, *args, &block)
      else
        super
      end
    end
  end
end
