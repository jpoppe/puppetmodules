Puppet::newtype(:war) do
  @doc = "Deploy and undeploy Tomcat WAR files"

  ensurable

  newparam(:name) do
    desc "name of warfile"
    isnamevar
  end

  newparam(:port) do
    desc "tomcat http connector port"
  end

  newparam(:instance) do
    desc "tomcat instance name"
  end

  newparam(:user) do
    desc "tomcat user"
  end

  newparam(:password) do
    desc "tomcat password"
  end

  newparam(:location) do
    desc "location of the directory with the context files"
  end

  newparam(:target) do
    desc "tomcat path to deploy the war file"
  end

  newparam(:version) do
    desc "version to deploy"
  end

end
