#!/usr/bin/env sh

_polybar_monitor_display_screen_all(){
    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        MONITOR=$m polybar --reload polybar-top &
        #MONITOR=$m polybar --reload polybar-bottom &
    done
}

_polybar_monitor_display_screen_only(){
    polybar --reload polybar-bottom-background & #This one is necessary to preserve the space between the Polybar and the window
    polybar --reload polybar-bottom-left &
    polybar --reload polybar-bottom-center &
    polybar --reload polybar-bottom-right &
}

_polybar_monitor_display_screen_only_alternative(){
    MONITOR=$m polybar --reload polybar-bottom &
}

_polybar_render(){
    # Terminate already running bar instances
    killall -q polybar

    if type "xrandr"; then
        _polybar_monitor_display_screen_all

        #_polybar_monitor_display_screen_only
        _polybar_monitor_display_screen_only_alternative
    else
        polybar --reload example &
    fi

    echo "Polybar launched..."
}

_polybar_render
