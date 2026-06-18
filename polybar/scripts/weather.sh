#!/usr/bin/env bash

set -euo pipefail

# SETTINGS vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

# API settings ________________________________________________________________

KEY="${OPENWEATHERMAP_API_KEY:-}"
KEY_FILE="${OPENWEATHERMAP_API_KEY_FILE:-$HOME/.ssh/owm_key}"
if [ "$KEY" = "" ] && [ -r "$KEY_FILE" ]; then
    KEY="$(cat "$KEY_FILE")"
fi
# if you leave these empty location will be picked based on your IP address
CITY_NAME=
COUNTRY_CODE=
# Desired output language
LANG="en"
# UNITS can be "metric", "imperial" or "kelvin". Set KNOTS to "yes" if you
# want the wind in knots:

#          | temperature | wind
# -----------------------------------
# metric   | Celsius     | km/h
# imperial | Fahrenheit  | miles/hour
# kelvin   | Kelvin      | km/h

UNITS="imperial"

# Color Settings ______________________________________________________________

COLOR_CLOUD="#606060"
COLOR_THUNDER="#d3b987"
COLOR_LIGHT_RAIN="#73cef4"
COLOR_HEAVY_RAIN="#b3deef"
COLOR_SNOW="#FFFFFF"
COLOR_FOG="#606060"
COLOR_TORNADO="#d3b987"
COLOR_SUN="#ffc24b"
COLOR_MOON="#FFFFFF"
COLOR_ERR="#f43753"
COLOR_WIND="#73cef4"
COLOR_COLD="#b3deef"
COLOR_HOT="#f43753"
COLOR_NORMAL_TEMP="#FFFFFF"

# Leave "" if you want the default polybar color
COLOR_TEXT=""
# Polybar settings ____________________________________________________________

# Font for the weather icons
WEATHER_FONT_CODE=0

# Font for the thermometer icon
TEMP_FONT_CODE=0

# Wind settings _______________________________________________________________

# Display info about the wind or not. yes/no
DISPLAY_WIND="yes"

# Show beaufort level in windicon
BEAUFORTICON="yes"

# Display in knots. yes/no
KNOTS="no"

# How many decimals after the floating point
DECIMALS=0

# Min. wind force required to display wind info (it depends on what
# measurement unit you have set: knots, m/s or mph). Set to 0 if you always
# want to display wind info. It's ignored if DISPLAY_WIND is false.

MIN_WIND=11

# Display the numeric wind force or not. If not, only the wind icon will
# appear. yes/no

DISPLAY_FORCE="yes"

# Display the wind unit if wind force is displayed. yes/no
DISPLAY_WIND_UNIT="yes"

# Thermometer settings ________________________________________________________

# When the thermometer icon turns red
HOT_TEMP=85

# When the thermometer icon turns blue
COLD_TEMP=50

# Other settings ______________________________________________________________

# Display the weather description. yes/no
DISPLAY_LABEL="yes"

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

COLOR_TEXT_BEGIN=""
COLOR_TEXT_END=""
ERR_MSG=""
LOCATION="Weather |"

if [[ -n "${COLOR_TEXT}" ]]; then
    COLOR_TEXT_BEGIN="%{F$COLOR_TEXT}"
    COLOR_TEXT_END="%{F-}"
fi

output_error() {
    echo "$LOCATION %{F$COLOR_ERR}%{F-} ${COLOR_TEXT_BEGIN}$1${COLOR_TEXT_END}"
    exit 0
}

curl_json() {
    curl -fsS --connect-timeout 2 --max-time 8 "$@"
}

if [[ -z "${KEY}" ]]; then
    output_error "missing API key"
fi

LOCATION_JSON="$(curl_json 'http://ip-api.com/json?fields=city,region,countryCode,lat,lon' || true)"
city=$(echo "$LOCATION_JSON" | jq -r ".city // empty")
region=$(echo "$LOCATION_JSON" | jq -r ".region // empty")
country=$(echo "$LOCATION_JSON" | jq -r ".countryCode // empty")
geo_lat=$(echo "$LOCATION_JSON" | jq -r ".lat // empty")
geo_lon=$(echo "$LOCATION_JSON" | jq -r ".lon // empty")

if [[ -n "${CITY_NAME}" ]]; then
    city="$CITY_NAME"
    region=""
    country="$COUNTRY_CODE"
    geo_lat=""
    geo_lon=""
fi

LOCATION="$city"
if [[ -n "${region}" ]]; then
    LOCATION="$LOCATION, $region"
fi
if [[ -n "${country}" ]]; then
    LOCATION="$LOCATION, $country"
fi
if [[ -z "${LOCATION}" ]]; then
    LOCATION="Weather"
fi
LOCATION="$LOCATION |"

if [[ -z "${city}" ]]; then
    output_error "location unavailable"
fi

if [[ -z "${geo_lat}" || -z "${geo_lon}" ]]; then
    geo_query="$city"
    if [[ -n "${region}" ]]; then
        geo_query="$geo_query,$region"
    fi
    if [[ -n "${country}" ]]; then
        geo_query="$geo_query,$country"
    fi
    geo="$(curl_json "https://api.openweathermap.org/geo/1.0/direct?q=${geo_query// /%20}&limit=1&appid=$KEY" || true)"
    geo_lat=$(echo "$geo" | jq -r '.[0].lat // empty')
    geo_lon=$(echo "$geo" | jq -r '.[0].lon // empty')
fi

if [[ -z "${geo_lat}" || -z "${geo_lon}" ]]; then
    output_error "coordinates unavailable"
fi

CITY_PARAM="lat=$geo_lat&lon=$geo_lon"

API="https://api.openweathermap.org/data/2.5"
current=$(curl_json "$API/weather?appid=$KEY&$CITY_PARAM&units=$UNITS" || true)

RESPONSE="${current}"

if [[ -z "${RESPONSE}" ]] || ! echo "$RESPONSE" | jq -e '.weather[0].id and .sys.sunrise and .sys.sunset and .main.temp and .wind.speed' > /dev/null; then
    output_error "weather unavailable"
fi

MAIN="$(echo "$RESPONSE" | jq -r .weather[0].main)"
WID="$(echo "$RESPONSE" | jq -r .weather[0].id)"
DESC="$(echo "$RESPONSE" | jq -r .weather[0].description)"
SUNRISE="$(echo "$RESPONSE" | jq -r .sys.sunrise)"
SUNSET="$(echo "$RESPONSE" | jq -r .sys.sunset)"
DATE="$(date +%s)"
WIND=""
TEMP="$(echo "$RESPONSE" | jq -r .main.temp)"
if [[ "${DISPLAY_LABEL}" == "yes" ]]; then
    DESCRIPTION="$(echo "$RESPONSE" | jq -r .weather[0].description)"
else
    DESCRIPTION=""
fi
PRESSURE="$(echo "$RESPONSE" | jq -r .main.pressure)"
HUMIDITY="$(echo "$RESPONSE" | jq -r .main.humidity)"

set_icons() {
    if ((WID <= 232)); then
        #Thunderstorm
        ICON_COLOR=$COLOR_THUNDER
        if ((DATE >= SUNRISE && DATE <= SUNSET)); then
            ICON=""
        else
            ICON=""
        fi
    elif ((WID <= 311)); then
        #Light drizzle
        ICON_COLOR=$COLOR_LIGHT_RAIN
        if ((DATE >= SUNRISE && DATE <= SUNSET)); then
            ICON=""
        else
            ICON=""
        fi
    elif ((WID <= 321)); then
        #Heavy drizzle
        ICON_COLOR=$COLOR_HEAVY_RAIN
        if ((DATE >= SUNRISE && DATE <= SUNSET)); then
            ICON=""
        else
            ICON=""
        fi
    elif ((WID <= 531)); then
        #Rain
        ICON_COLOR=$COLOR_HEAVY_RAIN
        if ((DATE >= SUNRISE && DATE <= SUNSET)); then
            ICON=""
        else
            ICON=""
        fi
    elif ((WID <= 622)); then
        #Snow
        ICON_COLOR=$COLOR_SNOW
        ICON=""
    elif ((WID <= 771)); then
        #Fog
        ICON_COLOR=$COLOR_FOG
        ICON=""
    elif ((WID == 781)); then
        #Tornado
        ICON_COLOR=$COLOR_TORNADO
        ICON=""
    elif ((WID == 800)); then
        #Clear sky
        if ((DATE >= SUNRISE && DATE <= SUNSET)); then
            ICON_COLOR=$COLOR_SUN
            ICON=""
        else
            ICON_COLOR=$COLOR_MOON
            ICON=""
        fi
    elif ((WID == 801)); then
        # Few clouds
        if ((DATE >= SUNRISE && DATE <= SUNSET)); then
            ICON_COLOR=$COLOR_SUN
            ICON=""
        else
            ICON_COLOR=$COLOR_MOON
            ICON=""
        fi
    elif ((WID <= 804)); then
        # Overcast
        ICON_COLOR=$COLOR_CLOUD
        ICON=""
    else
        ICON_COLOR=$COLOR_ERR
        ICON=""
    fi
    WIND=""
    WINDFORCE="$(echo "$RESPONSE" | jq .wind.speed)"
    WINDICON=""
    if [[ "${BEAUFORTICON}" == "yes" ]]; then
        if [[ "${UNITS}" != "imperial" ]]; then
            WINDFORCE2="$(echo "scale=$DECIMALS;$WINDFORCE * 3.6 / 1" | bc)"
        else
            WINDFORCE2="$(echo "scale=$DECIMALS;$WINDFORCE / 1" | bc)"
        fi
        if ((WINDFORCE2 <= 1)); then
            WINDICON=""
        elif ((WINDFORCE2 <= 5)); then
            WINDICON=""
        elif ((WINDFORCE2 <= 11)); then
            WINDICON=""
        elif ((WINDFORCE2 <= 19)); then
            WINDICON=""
        elif ((WINDFORCE2 <= 28)); then
            WINDICON=""
        elif ((WINDFORCE2 <= 38)); then
            WINDICON=""
        elif ((WINDFORCE2 <= 49)); then
            WINDICON=""
        elif ((WINDFORCE2 <= 61)); then
            WINDICON=""
        elif ((WINDFORCE2 <= 74)); then
            WINDICON=""
        elif ((WINDFORCE2 <= 88)); then
            WINDICON=""
        elif ((WINDFORCE2 <= 102)); then
            WINDICON=""
        elif ((WINDFORCE2 <= 117)); then
            WINDICON=""
        elif ((WINDFORCE2 > 117)); then
            WINDICON=""
        fi
    fi
    if [[ "${KNOTS}" == "yes" ]]; then
        case $UNITS in
            "imperial")
                # The division by one is necessary because scale works only for divisions. bc is stupid.
                WINDFORCE="$(echo "scale=$DECIMALS;$WINDFORCE * 0.8689762419 / 1" | bc)"
                ;;
            *)
                WINDFORCE="$(echo "scale=$DECIMALS;$WINDFORCE * 1.943844 / 1" | bc)"
                ;;
        esac
    else
        if [[ "${UNITS}" != "imperial" ]]; then
            # Conversion from m/s to km/h
            WINDFORCE="$(echo "scale=$DECIMALS;$WINDFORCE * 3.6 / 1" | bc)"
        else
            WINDFORCE="$(echo "scale=$DECIMALS;$WINDFORCE / 1" | bc)"
        fi
    fi
    if [[ "${DISPLAY_WIND}" == "yes" ]] && [[ "$(echo "$WINDFORCE >= $MIN_WIND" | bc -l)" -eq 1 ]]; then
        WIND="%{T$WEATHER_FONT_CODE}%{F$COLOR_WIND}$WINDICON%{F-}%{T-}"
        if [[ "${DISPLAY_FORCE}" == "yes" ]]; then
            WIND="$WIND $COLOR_TEXT_BEGIN$WINDFORCE$COLOR_TEXT_END"
            if [[ "${DISPLAY_WIND_UNIT}" == "yes" ]]; then
                if [[ "${KNOTS}" == "yes" ]]; then
                    WIND="$WIND ${COLOR_TEXT_BEGIN}kn$COLOR_TEXT_END"
                elif [[ "${UNITS}" == "imperial" ]]; then
                    WIND="$WIND ${COLOR_TEXT_BEGIN}mph$COLOR_TEXT_END"
                else
                    WIND="$WIND ${COLOR_TEXT_BEGIN}km/h$COLOR_TEXT_END"
                fi
            fi
        fi
        WIND="$WIND |"
    fi
    if [[ "${UNITS}" == "metric" ]]; then
        TEMP_ICON="󰔄"
    elif [[ "${UNITS}" == "imperial" ]]; then
        TEMP_ICON="󰔅"
    else
        TEMP_ICON="󰔆"
    fi

    TEMP="$(echo "$TEMP" | cut -d "." -f 1)"

    if ((TEMP <= COLD_TEMP)); then
        TEMP="%{F$COLOR_COLD}%{T$TEMP_FONT_CODE}%{T-}%{F-} $COLOR_TEXT_BEGIN$TEMP%{T$TEMP_FONT_CODE}$TEMP_ICON %{T-}$COLOR_TEXT_END"
    elif ((TEMP >= HOT_TEMP)); then
        TEMP="%{F$COLOR_HOT}%{T$TEMP_FONT_CODE}%{T-}%{F-} $COLOR_TEXT_BEGIN$TEMP%{T$TEMP_FONT_CODE}$TEMP_ICON %{T-}$COLOR_TEXT_END"
    else
        TEMP="%{F$COLOR_NORMAL_TEMP}%{T$TEMP_FONT_CODE}%{T-}%{F-} $COLOR_TEXT_BEGIN$TEMP%{T$TEMP_FONT_CODE}$TEMP_ICON %{T-}$COLOR_TEXT_END"
    fi
}

output_compact() {
    OUTPUT="$LOCATION $WIND%{T$WEATHER_FONT_CODE}%{F$ICON_COLOR}$ICON%{F-}%{T-} $ERR_MSG$COLOR_TEXT_BEGIN$DESCRIPTION$COLOR_TEXT_END | $TEMP "
    # echo "Output: $OUTPUT" >> "$HOME/.weather.log"
    echo "$OUTPUT"
}

set_icons
output_compact
