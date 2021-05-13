RESET="\033[0m"
BOLD="\033[1m"
READ_NORMAL_COLOR="\033[38;5;31m"
READ_ERROR_COLOR="\033[38;0;31m"
cecho () {
    declare -A colors;
    colors=(\
        ['black']='\E[0;47m'\
        ['red']='\E[0;31m'\
        ['green']='\E[0;32m'\
        ['yellow']='\E[0;33m'\
        ['blue']='\E[0;34m'\
        ['magenta']='\E[0;35m'\
        ['cyan']='\E[0;36m'\
        ['white']='\E[0;37m'\
    );
    local defaultMSG="No message passed.";
    local defaultColor="black";
    local defaultNewLine=true;
    while [[ $# -gt 1 ]];
    do
    key="$1";
    case $key in
        -c|--color)
            color="$2";
            shift;
        ;;
        -n|--noline)
            newLine=false;
        ;;
        *)
        ;;
    esac
    shift;
    done
    message=${1:-$defaultMSG};   # Defaults to default message.
    color=${color:-$defaultColor};   # Defaults to default color, if not specified.
    newLine=${newLine:-$defaultNewLine};
    echo -en "${colors[$color]}";
    echo -en "$message";
    if [ "$newLine" = true ] ; then
        echo;
    fi
    tput sgr0; #  Reset text attributes to normal without clearing screen.
    return;
}
success () {
    cecho -c 'green' "$@";
} 
warning () {
    cecho -c 'yellow' "$@";
}
error () {
    cecho -c 'red' "$@";
}
information () {
    cecho -c 'blue' "$@";
}
is_valid_ip() {
    IP_ADDRESS="$1"
    # Check if the format looks right_
    echo "$IP_ADDRESS" | egrep -qE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' || return 1
    #check that each octect is less than or equal to 255:
    echo $IP_ADDRESS | awk -F'.' '$1 <=255 && $2 <= 255 && $3 <=255 && $4 <= 255 {print "Y" } ' | grep -q Y || return 1
    return 0
}
#VARIABLES
IP_ADDRESS=$(ip route get 1 | awk '{print $NF;exit}')
APP_URL=http://"$HOSTNAME"
LARAVEL_VERSION_NO="8.5.17"
APP_NAME="Laravel"
HTTP_PORT="80"
HTTPS_PORT="443"
DB_PORT="3306"
DB_DATABASE="laravel"
DB_USERNAME="root"
DB_PASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w12 | head -n1)
LARAVEL_DIRECTORY="laravel"
OLD_LARAVEL_DIRECTORY="old-laravel"
clear
echo '

       __                                     __         
      / /   ____ _ _____ ____ _ _   __ ___   / /         
     / /   / __ `// ___// __ `/| | / // _ \ / /          
    / /___/ /_/ // /   / /_/ / | |/ //  __// /           
   /_________,_//_/    \__,__  |___/ \___//_/_           
      / __ \ ____   _____ / /__ ___   _____ (_)____  ___ 
     / / / // __ \ / ___// //_// _ \ / ___// //_  / / _ \
    / /_/ // /_/ // /__ / ,<  /  __// /   / /  / /_/  __/
   /_____/ \____/ \___//_/|_| \___//_/   /_/  /___/\___/ 

                                                                   
'
sleep 2

if [ "$EUID" -ne 0 ]; then
  error "Please run as root"
  warning "Byebye..."
  exit
fi



if ping -q -c 1 -W 1 google.com >/dev/null; then
  read -p "$(echo -e $BOLD$READ_NORMAL_COLOR">> Enter a valid IP Address or leave entry blank["$IP_ADDRESS"]: "$RESET)" IP_ADDRESS
  if [ "$IP_ADDRESS" = "" ]; then
    IP_ADDRESS=$(ip route get 1 | awk '{print $NF;exit}')
  else
    while ! is_valid_ip "$IP_ADDRESS"
    do    
        IP_ADDRESS=$(ip route get 1 | awk '{print $NF;exit}')    
        read -p "$(echo -e $BOLD$READ_ERROR_COLOR">> Not an IP. Re-enter or leave entry blank["$IP_ADDRESS"]: "$RESET)" IP_ADDRESS
        if [ "$IP_ADDRESS" = "" ]; then
          IP_ADDRESS=$(ip route get 1 | awk '{print $NF;exit}')
          break
        fi
    done
  fi
  success "<< $IP_ADDRESS"
  read -p "$(echo -e $BOLD$READ_NORMAL_COLOR">> Enter APP URL["$APP_URL"]: "$RESET)" INP_HOSTNAME
  if [ "$INP_HOSTNAME" != "" ]; then
    APP_URL="$INP_HOSTNAME"
  fi
  success "<< $APP_URL"
  read -p "$(echo -e $BOLD$READ_NORMAL_COLOR">> Enter application name["$APP_NAME"]: "$RESET)" INP_APP_NAME
  if [ "$INP_APP_NAME" != "" ]; then
    APP_NAME="$INP_APP_NAME"
  fi
  success "<< $APP_NAME"
  read -p "$(echo -e $BOLD$READ_NORMAL_COLOR">> Enter Laravel version no.["$LARAVEL_VERSION_NO"]: "$RESET)" INP_LARAVEL_VERSION_NO
  if [ "$INP_LARAVEL_VERSION_NO" != "" ]; then
    LARAVEL_VERSION_NO="$INP_LARAVEL_VERSION_NO"
  fi
  success "<< $LARAVEL_VERSION_NO"
  read -p "$(echo -e $BOLD$READ_NORMAL_COLOR">> Enter nginx HTTP port no.["$HTTP_PORT"]: "$RESET)" INP_HTTP_PORT
  if [ "$INP_HTTP_PORT" != "" ]; then
    HTTP_PORT="$INP_HTTP_PORT"
  fi
  success "<< $HTTP_PORT"
  read -p "$(echo -e $BOLD$READ_NORMAL_COLOR">> Enter nginx HTTPS port no.["$HTTPS_PORT"]: "$RESET)" INP_HTTPS_PORT
  if [ "$INP_HTTPS_PORT" != "" ]; then
    HTTPS_PORT="$INP_HTTPS_PORT"
  fi
  success "<< $HTTPS_PORT"
  read -p "$(echo -e $BOLD$READ_NORMAL_COLOR">> Enter database port no.["$DB_PORT"]: "$RESET)" INP_DB_PORT
  if [ "$INP_DB_PORT" != "" ]; then
    DB_PORT="$INP_DB_PORT"
  fi
  success "<< $DB_PORT"
  read -p "$(echo -e $BOLD$READ_NORMAL_COLOR">> Enter database name["$DB_DATABASE"]: "$RESET)" INP_DB_DATABASE
  if [ "$INP_DB_DATABASE" != "" ]; then
    DB_DATABASE="$INP_DB_DATABASE"
  fi
  success "<< $DB_DATABASE"
  read -p "$(echo -e $BOLD$READ_NORMAL_COLOR">> Enter database username["$DB_USERNAME"]: "$RESET)" INP_DB_USERNAME
  if [ "$INP_DB_USERNAME" != "" ]; then
    DB_USERNAME="$INP_DB_USERNAME"
  fi
  success "<< $DB_USERNAME"
  read -p "$(echo -e $BOLD$READ_NORMAL_COLOR">> Enter database password["$DB_PASSWORD"]: "$RESET)" INP_DB_PASSWORD
  if [ "$INP_DB_PASSWORD" != "" ]; then
    DB_PASSWORD="$INP_DB_PASSWORD"
  fi
  success "<< $DB_PASSWORD"
  sleep 2
  clear
  warning "Updating..."
  sudo yum update -y > /dev/null
  warning "Installing docker, wget, git, zip..."
  sudo yum install wget git zip unzip -y > /dev/null
  sudo curl -sSL http://get.docker.com | sh > /dev/null
  sudo curl -sL "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose > /dev/null
  sudo chmod +x /usr/local/bin/docker-compose
  docker-compose -v
  docker -v
  service docker start
  systemctl enable docker
  if [ -d "$LARAVEL_DIRECTORY" ]; then
    if [ -d "$OLD_LARAVEL_DIRECTORY" ]; then
      rm -rf "$OLD_LARAVEL_DIRECTORY"
      warning "$OLD_LARAVEL_DIRECTORY directory deleted!"
    fi
    mv "$LARAVEL_DIRECTORY" "$OLD_LARAVEL_DIRECTORY"
  fi
  warning "Downloading laravel-$LARAVEL_VERSION_NO..."
  curl -sL https://github.com/laravel/laravel/archive/v${LARAVEL_VERSION_NO}.tar.gz | tar xz >> /dev/null
  mv "laravel-${LARAVEL_VERSION_NO}" "$LARAVEL_DIRECTORY"
  cp "$LARAVEL_DIRECTORY"/.env.example "$LARAVEL_DIRECTORY"/.env
  sed -i 's/APP_NAME=Laravel/APP_NAME='"$APP_NAME"'/' "$LARAVEL_DIRECTORY"/.env
  ESCAPED_APP_URL=$(printf '%s\n' "$APP_URL" | sed -e 's/[\/&]/\\&/g')
  sed -i 's/APP_URL=http:\/\/localhost/APP_URL='"$ESCAPED_APP_URL"'/g' "$LARAVEL_DIRECTORY"/.env
  sed -i 's/DB_PORT=3306/DB_PORT='"$DB_PORT"'/' "$LARAVEL_DIRECTORY"/.env
  sed -i 's/DB_DATABASE=laravel/DB_DATABASE='"$DB_DATABASE"'/' "$LARAVEL_DIRECTORY"/.env
  sed -i 's/DB_USERNAME=root/DB_USERNAME='"$DB_USERNAME"'/' "$LARAVEL_DIRECTORY"/.env
  ESCAPED_REPLACE=$(printf '%s\n' "$DB_PASSWORD" | sed -e 's/[\/&]/\\&/g')
  sed -i 's/DB_PASSWORD=/DB_PASSWORD='"$ESCAPED_REPLACE"'/g' "$LARAVEL_DIRECTORY"/.env
  ESCAPED_POROTOCL_URL=$(echo "$APP_URL" | awk -F[/:] '{print $4}')
  sed -i 's/vhdm\.laravel/'"$ESCAPED_POROTOCL_URL"'/g' ./nginx/conf/nginx-vhost.conf
  sed -i 's/listen 80/listen '"$HTTP_PORT"'/' ./nginx/conf/nginx-vhost.conf
  clear
  sleep 2
  warning "docker-compose up ..."
  sleep 2
  sudo docker-compose --env-file "$LARAVEL_DIRECTORY"/.env up --build -d 
else
  error "The network is down or very slow!"
fi


