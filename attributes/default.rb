
normal[:serf][:version] = "0.5.0"
normal[:serf][:arch] = kernel['machine'] =~ /x86_64/ ? "amd64" : "386"
## TODO: Update the cookbook to only support linux (for now).
normal[:serf][:package_source] = "https://dl.bintray.com/mitchellh/serf/#{normal[:serf][:version]}_linux_#{normal[:serf][:arch]}.zip"

normal[:serf][:agent][:snapshot_path] = '/var/serf/snapshot'
normal[:serf][:agent][:event_handlers] = []
normal[:serf][:agent][:tags] = {}

normal[:serf][:agent_arguments] = "-config-file=/etc/serf/agent.config -config-dir=/etc/serf/config.d/"
