docker run -d \
    --name my-python2-container \
    --privileged \
    --device /dev/ttyAMA0 \  
    --device /dev/ttyUSB0 \  
    --device /dev/ttyUSB1 \  
    --device /dev/spidev0.0 \
    --device /dev/spidev0.1 \
    --device /dev/gpiomem \  
    -p 8443:8443 \
    -v /home/gengshang:/home/gengshang \  
    --restart always \
    code-server-python2:2.7.18 