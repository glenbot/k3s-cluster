__RAINBOWPALETTE="1"

function __colortext()
{
  echo -e "\e[$__RAINBOWPALETTE;$2m$1\e[0m"
}

function _echocolortext()
{
  color="${1}"
  echo $(__colortext "${2}" "${color}")
}

function echogreen() 
{
  color="32"
  if [[ "${1}" == "-n" ]]; then
    echo -n $(_echocolortext "${color}" "${2}")
  else
    echo $(_echocolortext "${color}" "${1}")
  fi
}

function echored() 
{
  color="31"
  if [[ "${1}" == "-n" ]]; then
    echo -n $(_echocolortext "${color}" "${2}")
  else
    echo $(_echocolortext "${color}" "${1}")
  fi
}

function echoblue() 
{
  color="34"
  if [[ "${1}" == "-n" ]]; then
    echo -n $(_echocolortext "${color}" "${2}")
  else
    echo $(_echocolortext "${color}" "${1}")
  fi
}

function echopurple() 
{
  color="35"
  if [[ "${1}" == "-n" ]]; then
    echo -n $(_echocolortext "${color}" "${2}")
  else
    echo $(_echocolortext "${color}" "${1}")
  fi
}

function echoyellow() 
{
  color="33"
  if [[ "${1}" == "-n" ]]; then
    echo -n $(_echocolortext "${color}" "${2}")
  else
    echo $(_echocolortext "${color}" "${1}")
  fi
}

function echocyan() 
{
  color="36"
  if [[ "${1}" == "-n" ]]; then
    echo -n $(_echocolortext "${color}" "${2}")
  else
    echo $(_echocolortext "${color}" "${1}")
  fi
}

vercomp () {
    if [[ $1 == $2 ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}

vergreater () {
    if [[ $1 == $2 ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 0
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 1
}