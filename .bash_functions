
function apt-history(){
    case "$1" in
      install)
            cat /var/log/dpkg.log | grep 'install '
            ;;
      upgrade|remove)
            cat /var/log/dpkg.log | grep $1
            ;;
      rollback)
            cat /var/log/dpkg.log | grep upgrade | \
                grep "$2" -A10000000 | \
                grep "$3" -B10000000 | \
                awk '{print $4"="$5}'
            ;;
      *)
            cat /var/log/dpkg.log
            ;;
    esac
}

cdd () {
    DIR=`pwd`
    while [ 1 ]
    do
        cd ..
        if [[ `pwd` == *source || `pwd` == *src ]]
        then
            return
        fi
        echo `pwd`

        if [[ `pwd` == / ]]
        then
            cd $DIR
            return
        fi
    done
}
mcd () {
    mkdir -p $1
    cd $1
}

