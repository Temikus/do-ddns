# do-ddns

Custom script for OpenWRT DDNS updates using Digital Ocean domains API

## Installation

- Make sure you have the curl package installed
- Copy script to /usr/lib/ddns/
- Make it executable:  
  `# chmod +x /usr/lib/ddns/update_do.sh`
- Specify the following parameters in the /etc/config/ddns:

  `Username` - the record id in the DO API structure.  
  `Password` - API Token  
  `Domain` - the domain managed by DO

- Set a custom script option in /etc/config/ddns:
  `option update_script '/usr/lib/ddns/update_do.sh'`
- ???
- PROFIT

NOTE: the script is parsed (not executed) inside send_update() function
of /usr/lib/ddns/dynamic_dns_functions.sh so you can use all available 
functions and global variables inside this script that were already defined
in dynamic_dns_updater.sh and dynamic_dns_functions.sh

See [DO API guide](https://developers.digitalocean.com/documentation/v2/#domains) for more info.
