# Script for sending user defined updates using DO API
# 2015 Artem Yakimenko <code at temik dot me>
#
# activated inside /etc/config/ddns by setting
#
# option update_script '/usr/lib/ddns/update_do.sh'
#
# the script is parsed (not executed) inside send_update() function
# of /usr/lib/ddns/dynamic_dns_functions.sh
# so you can use all available functions and global variables inside this script
# already defined in dynamic_dns_updater.sh and dynamic_dns_functions.sh
#
# Options are passed from /etc/config/ddns:

# Username - the record id in the DO API structure
# Password - API Token
# Domain - the domain managed by DO

local record_id=$URL_USER
local __URL="https://api.digitalocean.com/v2/domains/[DOMAIN]/records/[RECORD_ID]"
local __HEADER="Authorization: Bearer [PASSWORD]"
local __HEADER_CONTENT="Content-Type: application/json"
local __BODY='{"name":"@","data": "[IP]" }'
# inside url we need username and password

[ -z "$password" ] && write_log 14 "Service section not configured correctly! Missing 'password'"
[ -z "$username" ] && write_log 14 "Service section not configured correctly! Missing 'username'"
[ -z "$domain"] && write_log 14 "Service section not configured correctly! Missing 'domain'"

# do replaces in URL, header and body:
__URL=$(echo $__URL | sed -e "s#\[USERNAME\]#$URL_USER#g"  \
                               -e "s#\[DOMAIN\]#$domain#g" -e "s#\[RECORD_ID\]#$record_id#g")
__HEADER=$(echo $__HEADER| sed -e "s#\[PASSWORD\]#$URL_PASS#g")
__HEADER_CONTENT=$(echo $__HEADER_CONTENT)
__BODY=$(echo $__BODY | sed -e "s#\[IP\]#$__IP#g")

#Send PUT request
curl -X PUT -H "$__HEADER_CONTENT" -H "$__HEADER" -d "$__BODY" "$__URL" > $DATFILE 2>&1

write_log 7 "DDNS Provider answered:\n$(cat $DATFILE)"

# analyse provider answers
# If IP is contained in the returned datastructure - API call was sucessful
grep -E "$__IP" $DATFILE >/dev/null 2>&1
return $?      # "0" if IP has been changed or no change is needed
