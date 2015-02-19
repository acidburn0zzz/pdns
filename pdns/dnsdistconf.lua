

-- define the good servers
good={newServer("8.8.8.8"), newServer("8.8.4.4"), newServer("208.67.222.222"), newServer("208.67.220.220")}

-- this is where we send bad traffic
abuse={newServer("127.0.0.1:5300")}


-- called before we distribute a question
function blockFilter(remote, qname, qtype)
--	 print("Called about ",remote:tostring(), qname, qtype)

	 if(qname == "powerdns.org.")
	 then
		print("Blocking powerdns.org")
		return true
	 end
	 return false
end

counter=0

block=newSuffixNode()
block:add(newDNSName("ezdns.it."))
block:add(newDNSName("xxx."))

-- called to pick a downstream server
function pickServer(remote, qname, qtype) 
	 local servers
       	 if(block:check(qname))
       	 then 
       	    print("Sending to abuse pool: ",qname:tostring())	
	    servers=abuse 
	 else
		servers=good
	 end

	 counter=counter+1;
	 return servers[1 + (counter % #servers)]
end



