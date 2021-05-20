#!/bin/bash -e

APIKEY=${1:-${APIKEY}}
APIHOST=${2:-${APIHOST:-integ.uidapi.com}}
TESTEMAIL="validate@email.com"

if [ x$APIKEY = x ] ; then
    echo "Usage: $0 <api-key> [api-url]"
    echo "       api-url - default value: integ.uidapi.com"
    exit 1
fi

echoerr() { echo "$@" 1>&2; }

function api_get_raw() {
    URL="https://$APIHOST/$1"
    echoerr "GET $URL"
    echoerr "    $2"
    JSON=$(curl --location \
         --get \
         --silent \
         --request GET \
         --header "Authorization: Bearer $APIKEY" \
         --data-urlencode "$2" \
         "$URL")
    echo $JSON
}

function api_get() {
    URL="https://$APIHOST/$1"
    echoerr "GET $URL"
    echoerr "    $2"
    JSON=$(curl --location \
         --get \
         --silent \
         --request GET \
         --header "Authorization: Bearer $APIKEY" \
         --data-urlencode "$2" \
         "$URL")
    echo $JSON | jq .
}

function token_generate() {
    api_get "token/generate" "$1"
}

function v1_token_generate() {
    api_get "v1/token/generate" "$1"
}

function token_refresh() {
    api_get "token/refresh" "$1"
}

function v1_token_refresh() {
    api_get "v1/token/refresh" "$1"
}

function identity_map() {
    api_get_raw "identity/map" "$1"
}

function v1_identity_map() {
    api_get "v1/identity/map" "$1"
}

token_generate "email=$TESTEMAIL"
REFRESHTOKEN1=$(echo $JSON | jq -r '.refresh_token')

v1_token_generate "email=$TESTEMAIL"
REFRESHTOKEN2=$(echo $JSON | jq -r '.body.refresh_token')

token_generate "email_hash=yFmNYQbEv0Fac9XndBVvEBC45vkcBHYsRtvXDfYGifs="
REFRESHTOKEN3=$(echo $JSON | jq -r '.refresh_token')

v1_token_generate "email_hash=yFmNYQbEv0Fac9XndBVvEBC45vkcBHYsRtvXDfYGifs="
REFRESHTOKEN4=$(echo $JSON | jq -r '.body.refresh_token')

function test_refresh_token {
    token_refresh "refresh_token=$1"
    RT1=$(echo $JSON | jq -r '.refresh_token')

    token_refresh "refresh_token=$RT1"
    RT2=$(echo $JSON | jq -r '.refresh_token')

    v1_token_refresh "refresh_token=$RT1"
    RT3=$(echo $JSON | jq -r '.body.refresh_token')

    token_refresh "refresh_token=$RT2"
    RT4=$(echo $JSON | jq -r '.refresh_token')

    v1_token_refresh "refresh_token=$RT2"
    RT5=$(echo $JSON | jq -r '.body.refresh_token')

    token_refresh "refresh_token=$RT3"
    token_refresh "refresh_token=$RT4"
    token_refresh "refresh_token=$RT5"
}

test_refresh_token $REFRESHTOKEN1
# test_refresh_token $REFRESHTOKEN2
# test_refresh_token $REFRESHTOKEN3
# test_refresh_token $REFRESHTOKEN4

identity_map "email=$TESTEMAIL"
v1_identity_map "email=$TESTEMAIL"

identity_map "email_hash=yFmNYQbEv0Fac9XndBVvEBC45vkcBHYsRtvXDfYGifs="
v1_identity_map "email_hash=yFmNYQbEv0Fac9XndBVvEBC45vkcBHYsRtvXDfYGifs="
