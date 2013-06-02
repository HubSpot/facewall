# Stunnel with Brunch

## Installation

run:

    brew install stunnel

make a new directory (i did it in my brunch project) called stunnel, then cd into it and run these

    openssl genrsa 1024 &gt; stunnel.key
    openssl req -new -x509 -nodes -sha1 -days 365 -key stunnel.key &gt; stunnel.cert
    cat stunnel.key stunnel.cert &gt; stunnel.pem

when it asks you for cert information, it doesn't really matter all that much (since it's not a certified cert)

then make a file in that same directory called `dev_https` and put this into it:

    pid=

    cert = stunnel.pem
    foreground = yes
    output = stunnel.log

    [https]
    accept=443
    connect=3333
    TIMEOUTclose=1

`accept` is the port to run stunnel on. 443 is the default port for SSL, so you only need to navigate to [https://local.hubspotqa.com](https://local.company_domainqa.com) without a port.

`connect` is the port the brunch server is running on

## Running

from the directory you put the certificates and conf file in, run

    sudo stunnel dev_https