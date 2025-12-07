import pandas as pd
from geopy.geocoders import Nominatim
import firebase_admin
from firebase_admin import credentials, firestore
import time
import re
import sys

import os


import ssl
import certifi
import geopy.geocoders
from geopy.geocoders import Nominatim

def get_tier_and_tags(name):
    name_lower = name.lower()
    
    tier = 'tierB' # Default
    tags = ['Imported']
    
    # Tier S - Iconic / Must See
    if any(x in name_lower for x in ['łuczniczk', 'spichrz', 'wysp', 'przechodzący', 'katedr']):
        tier = 'tierS'
        tags.append('Ikona Miasta')
        if 'katedr' in name_lower: tags.append('Religia')
        if 'wysp' in name_lower: tags.append('Natura')

    # Tier A - Major attractions
    elif any(x in name_lower for x in ['fontann', 'muze', 'oper', 'filharmoni', 'kościół', 'fara', 'bazylik', 'młyn']):
        tier = 'tierA'
        if 'fontann' in name_lower: tags.append('Fontanna')
        if 'muze' in name_lower or 'młyn' in name_lower: tags.append('Muzeum')
        if 'kościół' in name_lower or 'fara' in name_lower or 'bazylik' in name_lower: tags.append('Religia')

    # Tier B - Statues, Nature, Parks
    elif any(x in name_lower for x in ['pomnik', 'rzeźb', 'popiers', 'wioślarz', 'lew', 'park', 'ogród', 'skwer', 'platan', 'dąb', 'kanał', 'śluz']):
        tier = 'tierB'
        if any(k in name_lower for k in ['pomnik', 'rzeźb', 'popiers', 'wioślarz', 'lew']): tags.append('Pomnik')
        if any(k in name_lower for k in ['park', 'ogród', 'skwer', 'platan', 'dąb', 'kanał', 'śluz']): tags.append('Natura')

    # Tier C - Plaques, Murals, Minor details
    elif any(x in name_lower for x in ['mural', 'graffiti', 'tablic', 'kamień', 'głaz', 'makieł']):
        tier = 'tierC'
        if 'mural' in name_lower or 'graffiti' in name_lower: tags.append('Mural')
        if 'tablic' in name_lower or 'kamień' in name_lower or 'głaz' in name_lower: tags.append('Historia')

    # Random bump to tier S for variety if it's already A
    if tier == 'tierA' and hash(name) % 5 == 0:
         tier = 'tierS'

    return tier, tags

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
        return

    print("Initializing Geocoder with SSL fix...")
    ctx = ssl.create_default_context(cafile=certifi.where())
    geopy.geocoders.options.default_ssl_context = ctx
    geolocator = Nominatim(user_agent="visit_bydgoszcz_importer_v1", ssl_context=ctx)

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
        
        tier, tags = get_tier_and_tags(name)
        
        data = {
            'id': doc_id,
            'name': name,
            'description': name, # Placeholder
            'shortDescription': address if address != 'nan' else '',
            'imageUrl': image_url,
            'tier': tier,
            'tags': tags,
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
            print(f"  Uploaded to Firestore: {tier} | {tags}")
        except Exception as e:
            print(f"  Error uploading: {e}")

if __name__ == "__main__":
    main()
