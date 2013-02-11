Puppet::Type.newtype(:allowed_host) do
  @doc = 'Ensure the supplied host is either absent or present from /etc/hosts.allow'

  newparam(:host, :namevar => true) do
    desc 'The host to manage in /etc/hosts.allow'
  end

  newparam(:service) do
    desc 'The service to allow for the given host'

    defaultto :ALL
  end

  newproperty(:ensure) do
    desc 'Ensure either the presence of absence of the supplied host.'

    defaultto :present

    newvalue :present do
      File.open('/etc/hosts.allow', 'a') { |fd| fd.puts "#{resource[:service]}: #{resource[:host]}" }
    end

    newvalue :absent do
      File.open('/etc/hosts.allow', 'rw') { |fd| fd.readlines.reject! {|line| line == "#{resource[:service]}: #{resource[:host]}" } }
    end

    def retrieve
      File.readlines('/etc/hosts.allow').map { |l|
        l.chomp
      }.include?("#{resource[:service]}: #{resource[:host]}") ? :present : :absent
    end
  end
end
