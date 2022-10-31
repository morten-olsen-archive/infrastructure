finish () {
    echo "$(date): Shutting down Wireguard"
    wg-quick down wg0
    exit 0
}

trap finish TERM INT QUIT

wg-quick up wg0

sleep infinity &
    wait $!
