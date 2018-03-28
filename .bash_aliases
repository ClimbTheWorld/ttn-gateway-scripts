# ~/.bashrc
alias showlog='sudo journalctl -u ttn-gateway.service'
alias svstat='systemctl status ttn-gateway.service & systemctl status ttnLogger.service'
alias pubip='curl ipinfo.io/ip'
