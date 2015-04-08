metadata :name        => "Upstart Service Agent",
         :description => "Agent to manage Upstart services",
         :author      => "Tron Thongsringklee",
         :license     => "MIT",
         :version     => "0.0.1",
         :url         => "https://github.com/thanandorn/mcollective-upstart-agent",
         :timeout     => 60

action "start", :description => "Start Upstart Service" do
  display :always

  input :service,
        :prompt      => "Service",
        :description => "Upstart service name to be executed",
        :type        => :string,
        :validation  => '[a-zA-Z0-9:/-]',
        :optional    => false,
        :maxlength   => 256

  output :status,
         :description => "The command output",
         :display_as  => "command output",
         :default     => "unknown status"
end

action "stop", :description => "Stop Upstart Service" do
  display :always

  input :service,
        :prompt      => "Service",
        :description => "Upstart service name to be executed",
        :type        => :string,
        :validation  => '[a-zA-Z0-9:/-]',
        :optional    => false,
        :maxlength   => 256

  output :status,
         :description => "The command output",
         :display_as  => "command output",
         :default     => "unknown status"
end

action "status", :description => "Status of Upstart Service" do
  display :always

  input :service,
        :prompt      => "Service",
        :description => "Upstart service name to be executed",
        :type        => :string,
        :validation  => '[a-zA-Z0-9:/-]',
        :optional    => false,
        :maxlength   => 256

  output :status,
         :description => "The command output",
         :display_as  => "command output",
         :default     => "unknown status"
end

action "restart", :description => "Restart Upstart Service" do
  display :always

  input :service,
        :prompt      => "Service",
        :description => "Upstart service name to be executed",
        :type        => :string,
        :validation  => '[a-zA-Z0-9:/-]',
        :optional    => false,
        :maxlength   => 256

  output :status,
         :description => "The command output",
         :display_as  => "command output",
         :default     => "unknown status"
end
