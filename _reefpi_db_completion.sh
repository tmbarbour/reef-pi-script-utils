_set_option_variables() {
    TOP_LEVEL_OPTIONS="db"
    DB_OPTIONS="buckets list show create update delete --help"
    INPUT_OPTION="-input"
    REEF_PI_LIST_ITEMS_CMD="sudo reef-pi db list "
    REEF_PI_BUCKETS_CMD="sudo reef-pi db buckets "
}

# helper logging method
_e() { echo "$1" >> log; }

_get_buckets() 
{
    BUCKETS=("$(${REEF_PI_BUCKETS_CMD} | tr '\n' ' ')")
}

_parse_reef_pi_json_for_items() {
PYTHON_CODE_TO_EXTRACT_ID_AND_NAME=$(cat <<END
import json
import sys

stdin_str = ""
for line in sys.stdin:
    stdin_str += line

resp = json.loads(stdin_str)

for key in resp:
    print("%s <%s>"%(resp[key]['id'],resp[key]['name']))
    
END
)
    CONFIGURED_ITEM_SUGGESTIONS="$(echo ${CONFIGURED_ITEMS_JSON} | python3 -c "$PYTHON_CODE_TO_EXTRACT_ID_AND_NAME" )"
}

_get_item_type() 
{
    case ${ITEM} in
        ph_calibration | ph_readings) #convert the oddball ph entries
            ITEM_TYPE="phprobes"
        ;;
        reef-pi | system | errors) #buckets without items
            ITEM_TYPE=""
        ;;
        *)
            ITEM_TYPE=$ITEM
        ;;
    esac

    ITEM_TYPE=$(echo $ITEM_TYPE | tr "_" "\n") #effectively strip off everything after the underscore
}

_get_reef_pi_configured_items()
{
    local CONFIGURED_ITEMS_JSON
    if [[ ! -z "${ITEM_TYPE}" ]]; then
        CONFIGURED_ITEMS_JSON="$($REEF_PI_LIST_ITEMS_CMD $ITEM_TYPE)"
        _parse_reef_pi_json_for_items
    fi
}

_get_configured_item_suggestions()
{    
    local CONFIGURED_ITEM_SUGGESTIONS 
    _get_reef_pi_configured_items

    local IFS=$'\n'      # Change IFS to new line - convert new lines to array
    local suggestions=($CONFIGURED_ITEM_SUGGESTIONS)

    if [ "${#suggestions[@]}" == "1" ]; then #If array is size one, then get the leading number
        local number="${suggestions[0]/%\ */}"
        COMPREPLY=("$number")
    else
        for i in "${!suggestions[@]}"; do # pad entries to screen width for 1 option per line
            suggestions[$i]="$(printf '%*s' "-$COLUMNS"  "${suggestions[$i]}")"
        done
        COMPREPLY=("${suggestions[@]}")
    fi
}

_get_item_options()
{
    local ITEM_TYPE ITEM
    ITEM=${prev}
    _get_item_type
    _get_configured_item_suggestions
}
_list_buckets()
{
    _get_buckets
    COMPREPLY=($(compgen -W "$BUCKETS" -- ${cur}))
}

_db_list_handler()
{
    case ${COMP_CWORD} in
        3) # completing 3rd term
            _list_buckets
            ;;
        *)
            COMPREPLY=()
            ;;
    esac  
}

_bucket_item_handler()
{
    case ${COMP_CWORD} in
        3) # completing 3rd term
            _list_buckets
            ;;
        4) # completing 4th term
            _get_item_options
            ;;
        *)
            COMPREPLY=()
            ;;
    esac  
}

_db_create_handler()
{
    case ${COMP_CWORD} in
        3) # completing 3rd term
            _list_buckets
            ;;
        4) # completing 4th term
            COMPREPLY=($(compgen -W "$INPUT_OPTION" -- ${cur}))
            ;;
        5) # completing 5th term
            COMPREPLY=($(compgen -f  -- "${cur}")) #files for input
            ;;
        *) 
            COMPREPLY=()
            ;;
    esac 
}

_db_delete_handler()
{
    _bucket_item_handler
}

_db_show_handler()
{
    _bucket_item_handler
}

_db_update_handler()
{
    case ${COMP_CWORD} in
        3) # completing 3rd term
            _list_buckets
            ;;
        4) # completing 4th term
            _get_item_options
            ;; 
        5) # completing 5th term
            COMPREPLY=($(compgen -W "$INPUT_OPTION" -- ${cur}))
            ;;
        6) # completing 6th term
            COMPREPLY=($(compgen -f  -- "${cur}")) #files for input
            ;;
        *) 
            COMPREPLY=()
            ;;
    esac 
}

_reef-pi_completions()
{
    local TOP_LEVEL_OPTIONS DB_OPTIONS
    _set_option_variables

    local cur prev max target
    cur=${COMP_WORDS[COMP_CWORD]}
    prev=${COMP_WORDS[COMP_CWORD-1]}
    if [[ "${#COMP_WORDS[@]}" -gt "3" ]]; then
        target=${COMP_WORDS[2]}
    fi

    case ${COMP_CWORD} in
        1) # one argument
            COMPREPLY=($(compgen -W "$TOP_LEVEL_OPTIONS" -- ${cur}))
            ;;
        2) # two arguments
            case ${prev} in
                db)  COMPREPLY=($(compgen -W "$DB_OPTIONS" -- ${cur})) ;;
            esac
            ;;
        3 | 4 | 5 | 6 ) # three or more
            case ${target} in
                buckets)  return  ;;
                list)     _db_list_handler ;;
                show)     _db_show_handler ;;
                create)   _db_create_handler ;;
                delete)   _db_delete_handler ;;
                update)   _db_update_handler ;;
            esac
            ;;
        *)
            COMPREPLY=()
            ;;
    esac
}
complete -F _reef-pi_completions reef-pi