#!/system/bin/sh
# combined_v26 byron-only NXP gate.
# Keep pandora and thales/goodix devices on their existing paths.

LOG=/tmp/recovery.log

log_msg() {
    echo "combined_v26 byron-nxp-gate: $1" >> "$LOG"
    log -t combined_v26_nxp_gate "$1" 2>/dev/null || true
}

wait_running() {
    name="$1"
    limit="$2"
    i=0
    while [ "$i" -lt "$limit" ]; do
        state="$(getprop "init.svc.$name")"
        [ "$state" = "running" ] && return 0
        sleep 1
        i=$((i + 1))
    done
    return 1
}

wait_stable_running() {
    name="$1"
    stable_needed="$2"
    limit="$3"
    stable=0
    i=0
    while [ "$i" -lt "$limit" ]; do
        state="$(getprop "init.svc.$name")"
        if [ "$state" = "running" ]; then
            stable=$((stable + 1))
            [ "$stable" -ge "$stable_needed" ] && return 0
        else
            stable=0
        fi
        sleep 1
        i=$((i + 1))
    done
    return 1
}

variant="$(getprop twrp.variant.detected)"
keymint="$(getprop ro.keymint)"
if [ "$variant" != "byron" ] || [ "$keymint" != "nxp" ]; then
    log_msg "skip variant=$variant keymint=$keymint"
    exit 0
fi

setprop twrp.byron.combined_v26.nxp_gate_started 1
setprop twrp.byron.combined_v26.nxp_gate_error ""
log_msg "start"

# The combined A16 image starts these two NXP JavaCard services together.
# On the failing byron dump both crash-loop before IWeaver/default is usable.
stop odm.keymint-strongbox-nxp
stop odm.weaver_nxp

start vendor.secure_element
if ! wait_running vendor.secure_element 30; then
    setprop twrp.byron.combined_v26.nxp_gate_error vendor_secure_element_not_running
    log_msg "vendor.secure_element not running"
    exit 0
fi

start se_omapi
if ! wait_running se_omapi 30; then
    setprop twrp.byron.combined_v26.nxp_gate_error se_omapi_not_running
    log_msg "se_omapi not running"
    exit 0
fi

# Give OMAPI/eSE a small bounded settle window before the NXP applet client starts.
sleep 4

start odm.weaver_nxp
if ! wait_stable_running odm.weaver_nxp 3 20; then
    setprop twrp.byron.combined_v26.nxp_gate_error weaver_nxp_not_stable
    log_msg "odm.weaver_nxp did not stay running"
    stop odm.weaver_nxp
    exit 0
fi

setprop twrp.byron.combined_v26.weaver_ready 1
log_msg "weaver_nxp stable; strongbox kept stopped in recovery"
exit 0
