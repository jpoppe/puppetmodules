Puppet::Type.type(:war).provide(:default) do
  desc "Tomcat WAR provider"

  commands :curl => "/usr/bin/curl"

  def create
  	#/opt/tomcatmulti/ 8310 /link_droid/1.0/context.xml&path=/link_droid'
    context = "#{resource[:location]}/#{resource[:instance]}/#{resource[:name]}/#{resource[:version]}/context.xml"
    credentials = "#{resource[:user]}:#{resource[:password]}"
    query = "http://localhost:#{resource[:port]}/manager/deploy?config=file:#{context}&path=#{resource[:target]}"
    Puppet.notice "Deploying #{resource[:target]} #{resource[:version]} @ #{resource[:instance]}"
    curl "-s", "--user", credentials, query
  end

  def destroy
    credentials = "#{resource[:user]}:#{resource[:password]}"
    query = "http://localhost:#{resource[:port]}/manager/undeploy?&path=#{resource[:target]}"
    Puppet.notice "Undeploying #{resource[:target]} @ #{resource[:instance]}"
    curl "-s", "--user", credentials, query
  end

  def exists?
      context = "/etc/tomcatmulti/#{resource[:instance]}/Catalina/localhost#{resource[:target]}.xml"
      if File.file? context then
        if resource[:ensure] == :absent
          destroy
            return
        else
          lines = IO.readlines(context)
          version = lines.first.split()[2]
          if version != resource[:version] then
              destroy
              create
          else
            return true
          end

        end

      end

  end

end
