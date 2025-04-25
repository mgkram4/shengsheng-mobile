import csv
import datetime
import http.client
import json
import unicodedata
from functools import wraps
from pathlib import Path
from urllib.parse import quote

import requests
from apscheduler.schedulers.background import BackgroundScheduler
from flask import (Flask, flash, jsonify, redirect, render_template, request,
                   session, url_for)
from flask_cors import CORS

from backend.models.metro_stations import (barcelona_metro_stations,
                                           madrid_metro_stations)

app = Flask(__name__, static_folder='static')
CORS(app)
app.secret_key = 'b9c10ee9d8d53b0e9d83e3931e4d8b6a'

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'logged_in' not in session:
            return redirect(url_for('login'))

        session['request_count'] = session.get('request_count', 0) + 1

        if session['request_count'] > 10:
            session.pop('logged_in', None)
            session.pop('request_count', None)
            return redirect(url_for('login'))

        return f(*args, **kwargs)
    return decorated_function

@app.route("/login", methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        if username == 'admin' and password == '123456':
            session['logged_in'] = True
            session['request_count'] = 0
            return redirect(url_for('homepage'))
        else:
            return "Invalid credentials"
    return render_template('login.html')

@app.route("/logout")
def logout():
    session.pop('logged_in', None)
    session.pop('request_count', None)
    return redirect(url_for('login'))

def get_data(endpoint, query, headers):
    conn = http.client.HTTPSConnection("idealista2.p.rapidapi.com")
    conn.request("GET", f"{endpoint}{query}", headers=headers)
    res = conn.getresponse()
    data = res.read().decode("utf-8")
    print(f"DEBUG: Raw response from {endpoint}{query}: {data}")

    try:
        json_data = json.loads(data)
    except json.JSONDecodeError as e:
        print(f"ERROR: Failed to decode JSON response: {e}")
        return {}

    return json_data

def normalize_text(text):
    return unicodedata.normalize('NFKD', text).encode('ASCII', 'ignore').decode('utf-8').lower()

headers = {
    'x-rapidapi-key': "f712876b48msh9651a5f1a373b64p12504ajsn9c5f096167ae",
    'x-rapidapi-host': "idealista2.p.rapidapi.com"
}

def data_retrevial(city, districts, operation="rent", max_price=None, min_price=None, min_rooms=None, 
                   floor_types=None, elevator=None):
    country = "es"
    city = normalize_text(city)
    districts_list = [normalize_text(district.strip()) for district in districts.splitlines() if district.strip()]

    if not districts_list:
        return {"error": "No districts provided"}

    district_results = {}
    for district in districts_list:
        query_district = quote(district)
        auto_complete_data = get_data("/auto-complete", f"?prefix={query_district}&country={country}", headers)

        if not auto_complete_data.get('locations'):
            continue

        matching_locations = [
            item for item in auto_complete_data['locations']
            if normalize_text(item.get("name", "")).find(district) != -1 and
            normalize_text(item.get("name", "")).find(city) != -1
        ]

        if matching_locations:
            metro_zones = [loc for loc in matching_locations if "metro" in loc.get("subType", "").lower()]
            regular_districts = [loc for loc in matching_locations if loc not in metro_zones]
            district_results[district] = metro_zones + regular_districts

            selected_names = [loc.get('name', 'Unknown') for loc in district_results[district]]
            print(f"Selected locations for {district.capitalize()}:\n" + "\n".join(selected_names))
        else:
            print(f"No matches found for district {district.capitalize()}")

    if not district_results:
        return {"error": "No matching locations found for any district"}

    rresults = []
    for district, locations in district_results.items():
        for location in locations:
            zoiID = location.get("zoiId")
            locationID = location.get("locationId")

            identifier_type = "zoiId" if zoiID else "locationId"
            identifier_value = zoiID or locationID

            if not identifier_value:
                print(f"WARNING: No zoiId or locationId available for location: {location.get('name', 'Unknown')}")
                continue

            query = f"?numPage=1&maxItems=40&sort=asc&locale=en&operation={operation}&country={country}&{identifier_type}={identifier_value}"
            if max_price:
                query += f"&maxPrice={max_price}"
            if min_price:
                query += f"&minPrice={min_price}"
            if min_rooms:
                query += f"&minRooms={min_rooms}"
            if floor_types:
                query += f"&floorHeights={','.join(floor_types)}"
            if elevator == "yes":
                query += f"&elevator=true"

            properties_data = get_data("/properties/list", query, headers)

            if 'elementList' in properties_data and properties_data['elementList']:
                for prop in properties_data['elementList']:
                    rresults.append({
                        "rooms": prop.get("rooms", ""),
                        "locationId": prop.get("locationId", ""),
                        "multimedia": prop.get("multimedia", []),
                        "price": prop.get("price", ""),
                        "status": prop.get("status", ""),
                        "size": prop.get("size", ""),
                        "address": prop.get("address", ""),
                        "bathrooms": prop.get("bathrooms", ""),
                        "url": prop.get("url", ""),
                        "district": district,
                        "contact_name": prop.get("contactInfo", {}).get("contactName", "N/A"),
                        "phone": prop.get("contactInfo", {}).get("phone1", {}).get("formattedPhone", "N/A"),
                        "images": prop.get("multimedia", {}).get("images", [])
                    })

    if rresults:
        timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        output_file = f"results_{timestamp}.csv"

        fieldnames = ["rooms", "locationId", "multimedia", "price", "status", "size",
                     "address", "bathrooms", "url", "district", "contact_name", "phone", "images"]
        with open(output_file, mode='w', newline='', encoding='utf-8') as file:
            writer = csv.DictWriter(file, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(rresults)

        first_location = next(iter(district_results.values()))[0]
        return {
            "success": True,
            "results": rresults,
            "file": output_file,
            "zoi_id": first_location.get("zoiId", "N/A"),
            "location_id": first_location.get("locationId", "N/A"),
            "district_results": district_results
        }
    else:
        return {
            "error": "No properties found with the specified criteria",
            "zoi_id": "N/A",
            "location_id": "N/A",
            "district_results": district_results
        }

latest_results = []
previous_results = []

def check_new_listings():
    global latest_results, previous_results

    results_dir = Path('.')
    result_files = list(results_dir.glob('results_*.csv'))
    if not result_files:
        return

    latest_file = max(result_files, key=lambda x: x.stat().st_mtime)

    new_results = []
    with open(latest_file, mode='r', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        new_results = list(reader)

    new_listings = []
    if previous_results:
        existing_urls = {item['url'] for item in previous_results}
        new_listings = [item for item in new_results if item['url'] not in existing_urls]

    previous_results = latest_results
    latest_results = new_results

    return new_listings

@app.route("/", methods=['GET', 'POST'])
@login_required
def homepage():
    try:
        if request.method == 'POST' or request.args.get('_method') == 'POST':
            city = request.form.get('city') or request.args.get('city')
            districts = request.form.get('districts') or request.args.get('districts')
            
            if not city:
                flash('Please enter a city', 'error')
                return render_template("index.html", 
                                    show_results=False, 
                                    madrid_metro_stations=madrid_metro_stations,
                                    barcelona_metro_stations=barcelona_metro_stations)
            
            # Store the city in session
            session['city'] = city.lower()

            if request.form.get('get-city') or request.args.get('get_city'):
                results = data_retrevial(
                    city=city,
                    districts=districts
                )

                if 'error' in results:
                    flash(results['error'], 'error')
                    return render_template("index.html", 
                                        show_results=False,
                                        madrid_metro_stations=madrid_metro_stations,
                                        barcelona_metro_stations=barcelona_metro_stations)

                district_choices = {}
                for district, locations in results.get('district_results', {}).items():
                    district_choices[district] = [loc.get('name', 'Unknown') for loc in locations]

                # Select metro stations based on city
                metro_stations = madrid_metro_stations if city.lower() == 'madrid' else barcelona_metro_stations if city.lower() == 'barcelona' else {}

                location_data = {
                    'city': city,
                    'district': districts,
                    'description': f"Search results for {city}",
                    'ZOI': results.get('zoi_id', 'N/A'),
                    'ID': results.get('location_id', 'N/A'),
                    'show_results': True,
                    'district_choices': district_choices,
                    'metro_stations': metro_stations,
                    'selected_city': city.lower(),
                    'madrid_metro_stations': madrid_metro_stations,
                    'barcelona_metro_stations': barcelona_metro_stations
                }
                return render_template("index.html", **location_data)

        # Default to Madrid metro stations for initial page load
        return render_template("index.html", 
                             show_results=False, 
                             madrid_metro_stations=madrid_metro_stations,
                             barcelona_metro_stations=barcelona_metro_stations,
                             metro_stations=madrid_metro_stations,
                             selected_city=session.get('city', 'madrid'))

    except Exception as e:
        flash(f'An error occurred: {str(e)}', 'error')
        return render_template("index.html", 
                             show_results=False, 
                             madrid_metro_stations=madrid_metro_stations,
                             barcelona_metro_stations=barcelona_metro_stations,
                             metro_stations=madrid_metro_stations)

@app.route("/central-location", methods=['POST'])
@login_required
def central_location():
    try:
        central_station = request.form.get('central_location')
        num_stations = int(request.form.get('number_of_stations', 2))
        city = session.get('city', 'madrid')

        if not central_station:
            flash('Please select a metro station', 'error')
            return redirect(url_for('homepage'))

        # Select correct metro stations based on city
        metro_stations = madrid_metro_stations if city.lower() == 'madrid' else barcelona_metro_stations
        
        # Find the line containing the central station
        selected_line = None
        selected_stations = []
        
        for line, stations in metro_stations.items():
            if central_station in stations:
                selected_line = line
                station_index = stations.index(central_station)
                # Get stations within range (before and after the central station)
                start_index = max(0, station_index - num_stations)
                end_index = min(len(stations), station_index + num_stations + 1)
                selected_stations = stations[start_index:end_index]
                break
        
        if not selected_stations:
            flash(f'Station "{central_station}" not found in {city.capitalize()} metro network', 'error')
            return redirect(url_for('homepage'))

        # Create a districts string with one station per line
        districts = '\n'.join(selected_stations)
        
        # Get property data for these stations
        results = data_retrevial(
            city=city,
            districts=districts
        )
        
        if 'error' in results:
            flash(results['error'], 'error')
            return redirect(url_for('homepage'))
            
        property_count = len(results.get('results', []))
        
        # Add success message with property count
        flash(f'Found {property_count} properties around {central_station} (including {len(selected_stations)-1} nearby stations on {selected_line})', 'success')
        
        # Redirect to result page instead of homepage
        return render_template('result.html',
                            city=city,
                            results=results.get('results', []),
                            result_count=property_count,
                            central_station=central_station,
                            selected_stations=selected_stations,
                            selected_line=selected_line)

    except Exception as e:
        flash(f'An error occurred: {str(e)}', 'error')
        return redirect(url_for('homepage'))

@app.route("/central-location-madrid", methods=['POST'])
@login_required
def central_location_madrid():
    return handle_central_location('madrid')

@app.route("/central-location-barcelona", methods=['POST'])
@login_required
def central_location_barcelona():
    return handle_central_location('barcelona')

def handle_central_location(city):
    try:
        central_station = request.form.get('central_location')
        num_stations = int(request.form.get('number_of_stations', 2))

        if not central_station:
            flash('Please select a metro station', 'error')
            return redirect(url_for('homepage'))

        # Select correct metro stations based on city
        metro_stations = madrid_metro_stations if city == 'madrid' else barcelona_metro_stations
        
        # Find the line containing the central station
        selected_line = None
        selected_stations = []
        
        for line, stations in metro_stations.items():
            if central_station in stations:
                selected_line = line
                station_index = stations.index(central_station)
                # Get stations within range (before and after the central station)
                start_index = max(0, station_index - num_stations)
                end_index = min(len(stations), station_index + num_stations + 1)
                selected_stations = stations[start_index:end_index]
                break
        
        if not selected_stations:
            flash(f'Station "{central_station}" not found in {city.capitalize()} metro network', 'error')
            return redirect(url_for('homepage'))

        # Create a districts string with one station per line
        districts = '\n'.join(selected_stations)
        
        # Store the selected stations and central station in the session
        session['selected_stations'] = selected_stations
        session['central_station'] = central_station
        session['city'] = city

        # Redirect to preferences page
        return redirect(url_for('preferences'))

    except Exception as e:
        flash(f'An error occurred: {str(e)}', 'error')
        return redirect(url_for('homepage'))

@app.route("/preferences", methods=['GET', 'POST'])
@login_required
def preferences():
    city = session.get('city')
    selected_stations = session.get('selected_stations')
    central_station = session.get('central_station')

    if not city or not selected_stations or not central_station:
        flash('Please select a central location first', 'error')
        return redirect(url_for('homepage'))

    return render_template('preferences.html',
                           city=city,
                           selected_stations=selected_stations,
                           central_station=central_station)

@app.route("/result", methods=['GET', 'POST'])
@login_required
def result_page():
    if request.method == 'POST':
        city = request.form.get('city')
        districts = request.form.get('districts')
        selected_district = request.form.get('selected_district')
        max_price = request.form.get('max_price')
        min_price = request.form.get('min_price')
        min_rooms = request.form.get('min_rooms')
        floor_types = request.form.getlist('floor_types')
        elevator = request.form.get('elevator')
        operation = request.form.get('operation', 'rent')

        results = data_retrevial(
            city=city,
            districts=selected_district,
            operation=operation,
            max_price=max_price,
            min_price=min_price,
            min_rooms=min_rooms,
            floor_types=floor_types,
            elevator=elevator
        )

        processed_results = []
        for result in results.get('results', []):
            multimedia = result.get('multimedia', [])
            if isinstance(multimedia, str):
                multimedia = [multimedia]
            elif isinstance(multimedia, dict):
                multimedia = [multimedia]
            elif not isinstance(multimedia, list):
                multimedia = []

            result['multimedia'] = multimedia
            processed_results.append(result)

        return render_template("result.html",
                             city=city,
                             results=processed_results,
                             result_count=len(processed_results))

    return redirect(url_for('homepage'))

@app.route("/submit-preferences", methods=['POST'])
@login_required
def submit_preferences():
    city = request.form.get('city')
    districts = request.form.get('districts')
    max_price = request.form.get('max_price')
    min_price = request.form.get('min_price')
    min_rooms = request.form.get('min_rooms')
    floor_types = request.form.getlist('floor_types')
    elevator = request.form.get('elevator')
    operation = request.form.get('operation', 'rent')

    results = data_retrevial(
        city=city,
        districts=districts,
        operation=operation,
        max_price=max_price,
        min_price=min_price,
        min_rooms=min_rooms,
        floor_types=floor_types,
        elevator=elevator
    )

    processed_results = []
    for result in results.get('results', []):
        multimedia = result.get('multimedia', [])
        if isinstance(multimedia, str):
            multimedia = [multimedia]
        elif isinstance(multimedia, dict):
            multimedia = [multimedia]
        elif not isinstance(multimedia, list):
            multimedia = []

        result['multimedia'] = multimedia
        processed_results.append(result)

    return render_template("result.html",
                         city=city,
                         results=processed_results,
                         result_count=len(processed_results))
    
    
    
@app.route("/automate", methods=['GET', 'POST'])
@login_required
def automate():
    # Get the selected stations from the session
    selected_stations = session.get('selected_stations', [])
    central_station = session.get('central_station', '')
    
    return render_template("automate.html", 
                          selected_stations=selected_stations,
                          central_station=central_station)

@app.route("/save-automation-settings", methods=['POST'])
@login_required
def save_automation_settings():
    # Get the stations that were selected for notifications
    stations_to_notify = request.form.getlist('station_notify')
    frequency = request.form.get('frequency', 'daily')
    
    # Save these settings to the user's profile or database
    # This is where you'd implement the actual saving logic
    
    flash('Notification settings saved successfully!', 'success')
    return redirect(url_for('automate'))

@app.route("/api/properties")
def get_properties():
    global latest_results
    return jsonify(latest_results)

@app.route("/api/new-listings")
def get_new_listings():
    new_listings = check_new_listings()
    return jsonify(new_listings if new_listings else [])

# Create API routes for metro stations data
@app.route('/api/metro/madrid', methods=['GET'])
def get_madrid_stations():
    """Returns all Madrid metro stations organized by line"""
    return jsonify({
        "status": "success",
        "data": madrid_metro_stations
    })

@app.route('/api/metro/barcelona', methods=['GET'])
def get_barcelona_stations():
    """Returns all Barcelona metro stations organized by line"""
    return jsonify({
        "status": "success",
        "data": barcelona_metro_stations
    })

@app.route('/api/metro/madrid/<line>', methods=['GET'])
def get_madrid_line_stations(line):
    """Returns stations for a specific Madrid metro line"""
    line_key = f"Line {line}"
    if line_key in madrid_metro_stations:
        return jsonify({
            "status": "success",
            "line": line_key,
            "stations": madrid_metro_stations[line_key]
        })
    else:
        return jsonify({
            "status": "error",
            "message": f"Line {line} not found"
        }), 404

@app.route('/api/metro/barcelona/<line>', methods=['GET'])
def get_barcelona_line_stations(line):
    """Returns stations for a specific Barcelona metro line"""
    # Handle special case for lines like "9 Nord"
    line_key = f"Line {line}"
    if line_key in barcelona_metro_stations:
        return jsonify({
            "status": "success",
            "line": line_key,
            "stations": barcelona_metro_stations[line_key]
        })
    else:
        return jsonify({
            "status": "error",
            "message": f"Line {line} not found"
        }), 404

def init_scheduler():
    scheduler = BackgroundScheduler()
    scheduler.add_job(func=check_new_listings, trigger="interval", hours=1)
    scheduler.start()

if __name__ == "__main__":
    init_scheduler()
    app.run(debug=True) 