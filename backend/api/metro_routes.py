from flask import Blueprint, jsonify

from backend.models.metro_stations import (barcelona_metro_stations,
                                           madrid_metro_stations)

metro_bp = Blueprint('metro', __name__)

@metro_bp.route('/api/metro/madrid', methods=['GET'])
def get_madrid_stations():
    """Returns all Madrid metro stations organized by line"""
    return jsonify({
        "status": "success",
        "data": madrid_metro_stations
    })

@metro_bp.route('/api/metro/barcelona', methods=['GET'])
def get_barcelona_stations():
    """Returns all Barcelona metro stations organized by line"""
    return jsonify({
        "status": "success",
        "data": barcelona_metro_stations
    })

@metro_bp.route('/api/metro/madrid/<line>', methods=['GET'])
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

@metro_bp.route('/api/metro/barcelona/<line>', methods=['GET'])
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