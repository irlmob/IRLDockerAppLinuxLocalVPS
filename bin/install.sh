#! /bin/sh
# @author: Denis Martin-Bruillot

# Adding or Removing Items to hosts file
# Use -h flag for help

export SYSTEM=$(uname -s)
export ARCHI=$(uname -m)
export VERSION=1.28.6
export defaultname=${PWD%%+(/)}           # trim however many trailing slashes exist
export defaultname=${defaultname##*/}     # remove everything before the last / that still remains

case "$1" in
  add)
  	if [ -f "$PWD/.servicename" ]; then echo "⛔️ \e[31mERROR!!! Found an exisiting installation!" && echo "\e[39m" && $(cat .servicename) || exit 0; fi
    echo ""
    echo "🚀 \e[32mStarting installation\e[39m"
    echo "\e[92m"
    read -p "Name your service, default: [${defaultname}]: " name
    name=${name:-${defaultname}}
    echo "\e[39m"
    echo "System: \e[96m${SYSTEM}\e[39m - Architecture: \e[96m${ARCHI}\e[39m"
    echo "\e[96m"
    docker --version
    echo ""
    wg --version
	echo "\e[39m"
	echo "🌏 \e[92m Downloading docker-compose-$s-$m - V$v to ${PWD}/bin\e[39m"
	echo ""
	mkdir -p bin
	curl -L "https://github.com/docker/compose/releases/download/$VERSION/docker-compose-$SYSTEM-$ARCHI" -o ./bin/docker-compose
	chmod +x ./bin/docker-compose
    echo "\e[96m"
	./bin/docker-compose --version
    echo "\e[39m"
    echo ${name} > $PWD/.servicename 
    cp -pr $PWD/bin/template $PWD/bin/${name}
    search="<BASEDIR>"
    sed -i "s@$search@$PWD@" $PWD/bin/${name}
    echo "\e[92m ✅ Adding Service to system"
    echo "->  ln -s $PWD/bin/${name} /usr/local/bin/${name}"
    echo "\e[39m"
    rm /usr/local/bin/${name} > /dev/null
    ln -s $PWD/bin/${name} /usr/local/bin/${name}
    echo "✅ Done. Service name: ${name}"
    ${name}

      ;;

  *)
      echo "Usage: "
      echo "install.sh [add]"
      exit 1
      ;;
esac

exit 0