import pandas as pd
from geopy.geocoders import Nominatim
import firebase_admin
from firebase_admin import credentials, firestore
import time
import re
import sys

import os

def main():
    print("Initializing Firebase...")
    try:
        if os.path.exists('service_account.json'):
            print("Found service_account.json, using it for credentials.")
            cred = credentials.Certificate('service_account.json')
            try:
                firebase_admin.initialize_app(cred)
            except ValueError:
                pass # Already initialized
        else:
            try:
                firebase_admin.initialize_app()
            except ValueError:
                pass
    except Exception as e:
        print(f"Error initializing Firebase app: {e}")

    try:
        db = firestore.client()
    except Exception as e:
        print(f"Error connecting to Firestore: {e}")
        print("Authentication missing. Please either:")
        print("1. Run: gcloud auth application-default login (if gcloud is installed)")
        print("2. Or download a Service Account Key from Firebase Console -> Project Settings -> Service Accounts")
        print("   and save it as 'service_account.json' in this directory.")
        return

    print("Initializing Geocoder...")
    geolocator = Nominatim(user_agent="visit_bydgoszcz_importer_v1")

    print("Reading Excel file...")
    try:
        df = pd.read_excel('src/visitbydgoszcz.xlsx')
    except Exception as e:
        print(f"Error reading Excel file: {e}")
        return

    print(f"Found {len(df)} rows.")

    for index, row in df.iterrows():
        name = str(row['description']).strip()
        address = str(row['txt-1']).strip()
        raw_image_url = str(row['grid src']).strip()
        
        if not name or name == 'nan':
            continue

        # Clean URL
        image_url = raw_image_url.replace('//images', '/images')
        
        print(f"Processing {index + 1}/{len(df)}: {name}...")

        # Geocode
        location_data = None
        if address and address != 'nan':
            try:
                # Append 'Bydgoszcz' if not present for better accuracy? 
                # The address usually has it, e.g. "Park im. Jana Kochanowskiego, Bydgoszcz"
                loc = geolocator.geocode(address)
                if loc:
                    location_data = firestore.GeoPoint(loc.latitude, loc.longitude)
                    print(f"  Geocoded: {address} -> {loc.latitude}, {loc.longitude}")
                else:
                    print(f"  Could not geocode: {address}")
            except Exception as e:
                print(f"  Error geocoding {address}: {e}")
            
            time.sleep(1.1) # Respect Nominatim rate limits (1 request per second)
        
        # Prepare data
        doc_id = re.sub(r'[^a-z0-9]', '_', name.lower())
        
        data = {
            'id': doc_id,
            'name': name,
            'description': name, # Placeholder
            'shortDescription': address if address != 'nan' else '',
            'imageUrl': image_url,
            'tier': 'tierB', # Default
            'tags': ['Imported'],
            'dataSource': 'excel',
            'aiPersonality': 'Jestem nowym miejscem na mapie Bydgoszczy.'
        }

        if location_data:
            data['location'] = location_data
        else:
             # Default to center of Bydgoszcz if no location found, or skip?
             # For now, let's put a placeholder so it doesn't crash the app if expected 
             data['location'] = firestore.GeoPoint(53.1235, 18.0084) # Bydgoszcz center

        try:
            db.collection('monuments').document(doc_id).set(data, merge=True)
            print("  Uploaded to Firestore.")
        except Exception as e:
            print(f"  Error uploading: {e}")

if __name__ == "__main__":
    main()
