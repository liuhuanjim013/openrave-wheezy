
.. bash-code::

 # https://gist.github.com/ompugao/ebb9cef52d50c58612d4#file-readme
 XSOCK=/tmp/.X11-unix
 XAUTH=/tmp/.docker.xauth
 xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

 docker run -t -i -v $XSOCK:$XSOCK -v $XAUTH:$XAUTH -e XAUTHORITY=$XAUTH liuhuanjim013/openrave-wheezy
 DISPLAY :0
 openrave.py -i
