#!/usr/bin/env zsh

_weather_getIcon() {
    case $1 in
        # Icons for weather-icons
        #01d) icon="";;
        #01n) icon="";;
        #02d) icon="";;
        #02n) icon="";;
        #03*) icon="";;
        #04*) icon="";;
        #09d) icon="";;
        #09n) icon="";;
        #10d) icon="";;
        #10n) icon="";;
        #11d) icon="";;
        #11n) icon="";;
        #13d) icon="";;
        #13n) icon="";;
        #50d) icon="";;
        #50n) icon="";;
        #*) icon="";

        # Icons for Font Awesome 5 Pro
        #01d) icon="";;
        #01n) icon="";;
        #02d) icon="";;
        #02n) icon="";;
        #03d) icon="";;
        #03n) icon="";;
        #04*) icon="";;
        #09*) icon="";;
        #10d) icon="";;
        #10n) icon="";;
        #11*) icon="";;
        #13*) icon="";;
        #50*) icon="";;
        #*) icon="";

        # Debug mode using simply text
        01d) icon="01d";;
        01n) icon="01n";;
        02d) icon="02d";;
        02n) icon="02n";;
        03d) icon="03d";;
        03n) icon="03n";;
        04*) icon="04*";;
        09*) icon="09*";;
        10d) icon="10d";;
        10n) icon="10n";;
        11*) icon="11*";;
        13*) icon="13*";;
        50*) icon="50*";;
        *) icon="";
    esac

    echo $icon
}

_weather(){
    KEY="52c37ed729a408cd4e3647aa39422e71"
    CITY="3448439"
    UNITS="metric"
    SYMBOL="°C"

    API="https://api.openweathermap.org/data/2.5"

    if [ -n "$CITY" ]; then
        if [ "$CITY" -eq "$CITY" ] 2>/dev/null; then
            CITY_PARAM="id=$CITY"
        else
            CITY_PARAM="q=$CITY"
        fi

        weather=$(curl -sf "$API/weather?appid=$KEY&$CITY_PARAM&units=$UNITS")
    else
        location=$(curl -sf https://location.services.mozilla.com/v1/geolocate?key=geoclue)

        if [ -n "$location" ]; then
            location_lat="$(echo "$location" | jq '.location.lat')"
            location_lon="$(echo "$location" | jq '.location.lng')"

            weather=$(curl -sf "$API/weather?appid=$KEY&lat=$location_lat&lon=$location_lon&units=$UNITS")
        fi
    fi

    if [ -n "$weather" ]; then
        weather_desc=$(echo "$weather" | jq -r ".weather[0].description")
        weather_temp=$(echo "$weather" | jq ".main.temp" | cut -d "." -f 1)
        weather_icon=$(echo "$weather" | jq -r ".weather[0].icon")

        echo "$(_weather_getIcon "$weather_icon")" "$weather_desc", "$weather_temp$SYMBOL"
    fi
}

_weather