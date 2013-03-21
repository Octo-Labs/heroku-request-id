module HerokuRequestId
  class Middleware

    def initialize(app)
        @app = app
    end

    @@html_comment = false

    def self.html_comment
      @@html_comment
    end

    def self.html_comment= hc
      @@html_comment = hc
    end

    @@log_line = true

    def self.log_line
      @@log_line
    end

    def self.log_line= hc
      @@log_line = hc
    end

    def call(env)
      @start = Time.now
      @request_id = env['HTTP_HEROKU_REQUEST_ID']
      @status, @headers, @response = @app.call(env)
      @stop = Time.now
      @elapsed = @stop - @start
      if self.class.log_line
        $stdout.puts("heroku-request-id=#{env['HTTP_HEROKU_REQUEST_ID']} measure=\"rack-request\" elapsed=#{@elapsed}")
      end
      [@status, @headers, self]
    end

    def each(&block)
      if self.class.html_comment && @headers["Content-Type"].include?("text/html")
        block.call("<!-- Heroku request id : #{@request_id} - Elapsed time : #{@elapsed} -->\n")
      end
      @response.each(&block)
    end

  end
end
