module HerokuRequestId
  class Middleware

    def initialize(app)
      @app = app
    end

    @@html_comment = false

    def self.html_comment
      @@html_comment
    end

    def self.html_comment= value
      @@html_comment = value
    end

    @@log_line = true

    def self.log_line
      @@log_line
    end

    def self.log_line= value
      @@log_line = value
    end

    @@x_request_id_replication = false

    def self.x_request_id_replication
      @@x_request_id_replication
    end

    def self.x_request_id_replication= value
      @@x_request_id_replication = value
    end

    def call(env)
      @start = Time.now
      @request_id = env['HTTP_HEROKU_REQUEST_ID']
      env["HTTP_X_REQUEST_ID"] = @request_id if self.class.x_request_id_replication
      @status, @headers, @response = @app.call(env)
      [@status, @headers, self]
    end

    def each(&block)
      @stop = Time.now
      @elapsed = @stop - @start
      if self.class.html_comment && @headers["Content-Type"] && @headers["Content-Type"].include?("text/html")
        block.call("<!-- Heroku request id : #{@request_id} - Elapsed time : #{@elapsed} -->\n")
      end
      if self.class.log_line
        $stdout.puts("heroku-request-id=#{@request_id} measure=\"rack-request\" elapsed=#{@elapsed}")
      end
      @response.each(&block)
    end

  end
end
