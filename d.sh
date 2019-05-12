#!/bin/bash

TAG=1.0.3
NAME=chrome-jdownloader2
USER=raykuo
PARAM='-p 5900:5900  -p 5800:5800'

case $1 in
    build)
	sudo docker build -t $USER/$NAME .
	;;

    del)
	# remove all stopped containers
	if [ ${2:-''} == 'container' ]; then
	  sudo docker rm -f $(sudo docker ps -a -q)
	fi

	# remove all untagged images
	if [ ${2:-''} == 'untag' ]; then
	  sudo docker rmi -f $(sudo docker images | grep "^<none>" | awk '{print $3}')
	fi

	# remove all images
	if [ ${2:-''} == 'all' ]; then
	    sudo docker rmi -f $(sudo docker images | awk '{print $3}')
	fi
	;;

    run)
	if [ ${2:-''} == '' ]; then
	    sudo docker run -d $PARAM $USER/$NAME
	fi
	if [ ${2:-''} == 'bash' ]; then
	    sudo docker run -i -t $PARAM $USER/$NAME bash
	fi
	;;

    save)
	sudo docker save -o ~/$NAME.tar $USER/$NAME
	sudo chmod 777 ~/$NAME.tar
	;;

    stop)
	# stop containers
	if [ ${2:-''} == '' ]; then
	    sudo docker stop $(sudo docker ps | awk -v VAR_FN=$USER/$NAME '{if ($2==VAR_FN) {printf $1}}')
	fi

	# stop all containers
	if [ ${2:-''} == 'all' ]; then
	    sudo docker stop $(sudo docker ps -a -q)
	fi
	;;

   tag)
	sudo docker tag $USER/$NAME $USER/$NAME:$TAG
	;;

    start)
        sudo docker start $(sudo docker ps -a | awk -v VAR_FN=$USER/$NAME '{if ($2==VAR_FN) {printf $1}}')
	;;

    *)
#	echo 'd [build | run | run [bash] | save | del [all] | stop [all]]'
	while true; do
	    echo '1) build image'
	    echo '2) run image (background)'
	    echo '3) run image (bash)'
	    echo '4) del stopped containers'
	    echo '5) del untagged images'
	    echo '6) del all images'
	    echo '7) stop container'
	    echo '8) stop all'
	    echo '9) tag version' $TAG
	    echo 'a) start stopped container'
	    echo 'i) images list'
	    echo 'c) container list'
	    echo 's) save image to HOME directory'
	    read -p 'Choise (Ctrl-C to Exit): ' input

	    case $input in
		1) ./d.sh build ;;
		2) ./d.sh run ;;
		3) ./d.sh run bash ;;
		4) ./d.sh del container ;;
		5) ./d.sh del untag ;;
		6) ./d.sh del all ;;
		7) ./d.sh stop ;;
		8) ./d.sh stop all ;;
		9) ./d.sh tag ;;
		a) ./d.sh start ;;
		i) sudo docker images ;;
		c) sudo docker ps -a ;;
		s) ./d.sh save ;;
	    esac
	done
	;;
esac


