#!/usr/bin/python

import sys, argparse, requests, json
import pprint
from auth import reef_pi_secrets

def main(argv):
    parse_args(argv)

    switcher = {
        "list": list_handler,
        "show": show_handler,
        "buckets": buckets_handler
    }
    # Get the function from switcher dictionary
    func = switcher.get(args.action, lambda: "Invalid action option")
    # Execute the function
    func()

def list_handler():
    session = connectToReefPiApi()
    url = {
        "analog_inputs":  'http://localhost/api/analog_inputs',
        "ato":            'http://localhost/api/atos',
        "doser":          'http://localhost/api/doser/pumps',
        "drivers":        'http://localhost/api/drivers',
        "equipment":      'http://localhost/api/equipment',
        "errors":         'http://localhost/api/errors',
        "inlets":         'http://localhost/api/inlets',
        "jacks":          'http://localhost/api/jacks',
        "lightings":      'http://localhost/api/lights',
        "macro":          'http://localhost/api/macros',
        "outlets":        'http://localhost/api/outlets',
        "ph_calibration": 'http://localhost/api/',
        "ph_readings":    'http://localhost/api/',
        "phprobes":       'http://localhost/api/phprobes',
        "reef-pi":        'http://localhost/api/',
        "settings":       'http://localhost/api/settings',
        "temperature":    'http://localhost/api/tcs',
        "temperature_calibration": 'http://localhost/api/',
        "timers":         'http://localhost/api/timers'
    }

    if(url.has_key(args.type)):
        session = connectToReefPiApi()
        response = session.get(url[args.type])
        output_json(response.json())

def show_handler():
    session = connectToReefPiApi()
    url = {
        "analog_inputs":  'http://localhost/api/analog_inputs/{}',
        "ato":            'http://localhost/api/atos/{}',
        "ato_usage":      'http://localhost/api/atos/{}/usage',
        "doser":          'http://localhost/api/doser/pumps/{}',
        "doser_usage":    'http://localhost/api/doser/pumps/{}/usage',
        "drivers":        'http://localhost/api/drivers/{}',
        "equipment":      'http://localhost/api/equipment/{}',
        "errors":         'http://localhost/api/errors/{}',
        "inlets":         'http://localhost/api/inlets/{}',
        "jacks":          'http://localhost/api/jacks/{}',
        "lightings":      'http://localhost/api/lights/{}',
        "macro":          'http://localhost/api/macros/{}',
        "outlets":        'http://localhost/api/outlets/{}',
        "ph_read":        'http://localhost/api/phprobes/{}/read',
        "ph_readings":    'http://localhost/api/phprobes/{}/readings',
        "phprobes":       'http://localhost/api/phprobes/{}',
        "settings":       'http://localhost/api/settings',
        "temperature":    'http://localhost/api/tcs/{}',
        "temperature_current": 'http://localhost/api/tcs/{}/current_reading',
        "temperature_usage":   'http://localhost/api/tcs/{}/usage',
        "timers":         'http://localhost/api/timers'
    }

    print(args)
    if(url.has_key(args.type)):
        url_id = url[args.type].format(args.id)
        print(url_id)
        session = connectToReefPiApi()
        response = session.get(url_id)
        if (response.status_code == 200):
            output_json(response.json())
        else:
            print("{} response from API call '{}'".format(response.status_code,url_id))
    
def buckets_handler():
    for item in type_options().sort():
        print(item)

def connectToReefPiApi():
    session = requests.Session()   
    session.post('http://localhost/auth/signin', data=json.dumps(reef_pi_secrets.authorization))
    return session

def output_json(json_val):   
    if args.value:
        for entry in json_val:
            if (entry.has_key(args.value)):
                print(entry[args.value])
            else:
                print("value '{}' does not exist, try one of: {}".format(args.value, json_val[0].keys()))
                return
    else:
        if args.pretty:
            print(json.dumps(json_val, indent=4, sort_keys=True))
        else:
            print(json.dumps(json_val))

def type_options():
    bucket_list =  ['analog_inputs', 'ato', 'doser', 'drivers', 'equipment', 'errors', 'inlets', 'jacks', 
                    'lightings', 'macro', 'outlets', 'ph_calibration', 'ph_readings', 'phprobes', 
                    'settings', 'temperature', 'timers'] 
    return bucket_list

def show_options():
    show_list =  ['ato_usage', 'doser_usage', 'temperature_current', 'temperature_usage'] 
    for item in type_options():
        show_list.append(item)
    return show_list.sort()


def parse_args(argv):
    parser = argparse.ArgumentParser(argument_default=argparse.SUPPRESS)
   
    subparsers = parser.add_subparsers(dest='action')
    parser_list = subparsers.add_parser('list', help='List reef-pi items')
    parser_list.add_argument("type",choices=type_options())
    parser_list.add_argument("--pretty", help="Pretty print output", default=False, action='store_true')
    parser_list.add_argument("--value", help="Extract value from json (dot notation)")

    parser_show = subparsers.add_parser('show', help='Show reef-pi items')
    parser_show.add_argument("type",choices=show_options())
    parser_show.add_argument("id",type=int)
    parser_show.add_argument("--pretty", help="Pretty print output", default=False, action='store_true')

    parser_show = subparsers.add_parser('buckets', help='Show reef-pi buckets')

    global args
    args = parser.parse_args()

if __name__ == "__main__":
   main(sys.argv[1:])    