module MCollective
  class Application::Upstart < Application
    description "Manages upstart services"

    usage <<-END_OF_USAGE
mco upstart <SERVICE> <ACTION>

ACTION can be one of the following :

    start   - start service
    stop    - stop service
    restart - restart or reload service
    status  - determine the current staus of the remote service
END_OF_USAGE

    option :yes,
           :arguments   => ["--yes", "-y"],
           :description => "Assume yes on any prompts",
           :type        => :bool

    def handle_message(action, message, *args)
      messages = {1 => "Please specify service name and action",
                  2 => "Action has to be one of start, stop, restart or status",
                  3 => "Do you really want to operate on services unfiltered? (y/n): "}

      send(action, messages[message] % args)
    end

    def post_option_parser(configuration)
      if ARGV.size < 2
        handle_message(:raise, 1)
      else
        valid_actions = ['start', 'stop', 'restart', 'status']

        if valid_actions.include?(ARGV[0])
          configuration[:action] = ARGV.shift
          configuration[:service] = ARGV.shift
        elsif valid_actions.include?(ARGV[1])
          configuration[:service] = ARGV.shift
          configuration[:action] = ARGV.shift
        else
          handle_message(:raise, 2)
        end
      end
    end

    def validate_configuration(configuration)
      unless configuration[:action] == 'status'
        if Util.empty_filter?(options[:filter]) && !configuration[:yes]
          handle_message(:print, 3)

          STDOUT.flush

          exit(1) unless STDIN.gets.strip.match(/^(?:y|yes)$/i)
        end
      end
    end

    def main
      # We have to change our process name in order to hide name of the
      # upstart we are looking for from our execution arguments. Puppet
      # provider will look at the process list for the name of the upstart
      # it wants to manage and it might find us with our arguments there
      # which is not what we really want ...
      $0 = 'mco'

      upstart = rpcclient('upstart')
      upstart_result = upstart.send(configuration[:action], :service => configuration[:service])

      sender_width = upstart_result.map{|s| s[:sender]}.map{|s| s.length}.max + 3
      pattern = "%%%ds: %%s" % sender_width

      upstart_result.each do |result|
        if result[:statuscode] == 0
          if upstart.verbose
            puts pattern % [result[:sender], result[:data][:status]]
          else
            case configuration[:action]
            when 'start', 'restart'
              puts(pattern % [result[:sender], result[:data][:status]]) unless result[:data][:status] == 'running'
            when 'stop'
              puts(pattern % [result[:sender], result[:data][:status]]) unless result[:data][:status] == 'stopped'
            when 'status'
              puts(pattern % [result[:sender], result[:data][:status]])
            end
          end
        else
          puts(pattern % [result[:sender], result[:statusmsg]])
        end
      end

      puts

      printrpcstats :summarize => true, :caption => "%s Service results" % configuration[:action]
      halt(upstart.stats)
    end
  end
end
