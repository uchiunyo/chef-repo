#zabbix-server.conf default param
default["zabbix"]["server"]["DebugLevel"] = 3
default["zabbix"]["server"]["DBHost"] = "localhost"
default["zabbix"]["server"]["DBName"] = "zabbix"
default["zabbix"]["server"]["DBUser"] = "zabbix"
default["zabbix"]["server"]["DBPassword"] = "zabbix"
default["zabbix"]["server"]["ListenIP"] = "0.0.0.0"
default["zabbix"]["server"]["Timeout"] = "30"

#zabbix-agent.conf default param
default["zabbix"]["agent"]["DebugLevel"] = 3
default["zabbix"]["agent"]["Server"] = "127.0.0.1"
default["zabbix"]["agent"]["ListenIP"] = "0.0.0.0"
default["zabbix"]["agent"]["StartAgents"] = 3
default["zabbix"]["agent"]["ServerActive"] = "127.0.0.1"
default["zabbix"]["agent"]["Hostname"] = node['hostname']
default["zabbix"]["agent"]["Timeout"] = 3
