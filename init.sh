#!/usr/bin/env sh

# Start Tailscale
if [ "$TS_RUN_TAILSCALE" = true ] ; then
    /usr/local/bin/containerboot &
fi

# Start the derp server
/usr/local/bin/derper --hostname $TS_DERP_HOSTNAME --bootstrap-dns-names $TS_DERP_HOSTNAME -certmode $TS_DERP_CERTMODE -certdir /root/derper/$TS_DERP_HOSTNAME --stun --verify-clients=$TS_DERP_VERIFY_CLIENTS --http-port=$TS_DERP_HTTP_PORT -a :$TS_DERP_LISTEN_PORT --stun-port=$TS_DERP_STUN_PORT
