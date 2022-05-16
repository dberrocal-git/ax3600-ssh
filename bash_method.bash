rawurlencode() {
  local string="${1}"
  local strlen=${#string}
  local encoded=""
  local pos c o

  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * )               printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
  echo "${encoded}"    # You can either set a return variable (FASTER)
  REPLY="${encoded}"   #+or echo the result (EASIER)... or both... :p
}

xiaomiCmd() {
    parsed=$(rawurlencode "$1")
    url="http://192.168.31.1/cgi-bin/luci/;stok=$stok/api/misystem/set_config_iotdev?bssid=redmi&user_id=doctor&ssid=-h%0A$parsed%0A"
    echo $url
    curl "$url"
    echo
}

enableSsh() {
    xiaomiCmd "nvram set ssh_en=1;nvram commit"
    xiaomiCmd "sed -i '/flg_ssh.*release/ { :a; N; /fi/! ba };/return 0/d' /etc/init.d/dropbear"
    xiaomiCmd "echo -e '$password\n$password' | passwd root"
    xiaomiCmd "/etc/init.d/dropbear enable;/etc/init.d/dropbear start"
}
echo your have to enter stok and password variables before running enableSsh:
echo 'stok=<STOK>'
echo 'password=<PASSWORD>'
echo enableSsh