module MCollective
  module Agent
    class Upstart<RPC::Agent
      # Activate only on machines that have upstart installed
      activate_when do
        File.exists?("/sbin/initctl")
      end
      action "start" do
        cmd = "start " + request.data[:service]
        reply[:status] = run(cmd, :stdout => :out,
                                  :stderr => :err,
                                  :chomp  => true)
      end
      action "restart" do
        cmd = "restart " + request.data[:service]
        reply[:status] = run(cmd, :stdout => :out,
                                  :stderr => :err,
                                  :chomp  => true)
      end
      action "stop" do
        cmd = "stop " + request.data[:service]
        reply[:status] = run(cmd, :stdout => :out,
                                  :stderr => :err,
                                  :chomp  => true)
      end
      action "status" do
        cmd = "status " + request.data[:service]
        reply[:status] = run(cmd, :stdout => :out,
                                  :stderr => :err,
                                  :chomp  => true)
      end
    end
  end
end
