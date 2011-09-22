Facter.add("location") do
	setcode do
		begin
			Facter.fqdn
		rescue
			Facter.loadfacts()
		end
		Facter.value('fqdn').instance_eval do
			if count(".") == 4
				split(".")[2].downcase
			elsif Facter.value('fqdn') =~ /mp-devlocal/
				"pd"
			elsif Facter.value('fqdn') =~ /qa-mp.com/
				"qa"                     
			else
				"none"
			end
		end
	end
end
