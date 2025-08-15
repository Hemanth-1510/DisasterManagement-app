const disasterPrecautions = {
  'flood': [
    'Move to higher ground immediately and avoid low-lying areas.',
    'Do not walk, swim or drive through flood waters; as little as 6 inches of moving water can knock you down.',
    'Unplug appliances; turn off electricity and gas at the main switches if instructed.',
    'Keep emergency kit: water, non‑perishable food, flashlight, batteries, medications, documents in waterproof bag.',
    'Listen to official weather bulletins and evacuation orders.',
  ],
  'cyclone': [
    'Secure outdoor objects; reinforce doors and windows (use storm shutters).',
    'Prepare a safe room away from glass; keep a battery‑powered radio and power bank.',
    'Stock up on clean water (at least 3 liters per person per day) and non‑perishable food for 3 days.',
    'Fill vehicles with fuel; charge phones; plan evacuation routes.',
    'Stay indoors during the eye of the storm; conditions may worsen suddenly afterwards.',
  ],
  'earthquake': [
    'Practice Drop, Cover, and Hold On under sturdy furniture; stay away from windows.',
    'Secure heavy furniture and water heaters to walls; store breakables low.',
    'Prepare a family communication plan; know safe spots in each room.',
    'If outdoors, move to open area away from buildings, streetlights, and utility wires.',
    'After shaking stops, expect aftershocks; check for gas leaks and structural damage.',
  ],
  'fire': [
    'Install smoke alarms on every level and test monthly.',
    'Keep fire extinguishers readily accessible; know how to use PASS (Pull, Aim, Squeeze, Sweep).',
    'Create and practice a two‑exit home evacuation plan; designate meeting point.',
    'Never use elevators during a fire; crawl low under smoke.',
    'Maintain defensible space around structures in wildfire‑prone areas.',
  ],
  'tsunami': [
    'If near coast and you feel strong/long earthquake, move immediately to higher ground (30m elevation or 3km inland).',
    'Follow evacuation routes; do not wait for official warnings if natural signs present.',
    'Stay away from beaches and rivers; multiple waves may arrive for hours.',
  ],
  'heatwave': [
    'Stay hydrated; avoid alcohol and caffeine; take frequent breaks in shade/AC.',
    'Check on elderly, infants, and pets; never leave anyone in a parked car.',
    'Wear light‑colored, loose clothing; use sunscreen and hats.',
  ],
  'landslide': [
    'Avoid steep slopes during heavy rain; watch for cracks, tilting trees, or unusual sounds.',
    'Have an evacuation plan; move to higher, stable ground if signs appear.',
  ],
  'pandemic': [
    'Follow public health guidance; keep vaccinations up to date.',
    'Wash hands frequently; wear masks in crowded indoor spaces when advised.',
    'Stay home if sick; isolate and test as recommended.',
  ],
};

const disasterInstructions = {
  'flood': [
    'Evacuate if instructed by authorities and avoid bridges over fast‑moving water.',
    'Turn off utilities if safe; do not touch electrical equipment in water.',
    'After flooding, avoid floodwater due to contamination; document damage and clean with protective gear.',
  ],
  'cyclone': [
    'Follow evacuation orders promptly; take emergency kit and important documents.',
    'During cyclone: stay in interior room on lowest level; keep away from windows.',
    'After cyclone: avoid downed power lines and floodwaters; boil water until safe.',
  ],
  'earthquake': [
    'During shaking: Drop, Cover, Hold On; if in bed, stay and protect head with pillow.',
    'If driving, pull over and stop; avoid overpasses, power lines; set parking brake.',
    'After: check for injuries; turn off gas if you smell it; use text messages vs calls.',
  ],
  'fire': [
    'If clothes catch fire: Stop, Drop, and Roll; cool burns with water for 20 minutes.',
    'If trapped: block smoke with wet cloths, signal at window; call emergency services.',
    'After: do not re‑enter until authorities declare it safe.',
  ],
  'tsunami': [
    'Move inland/uphill immediately; do not wait for sirens if natural warning signs occur.',
    'Stay at high ground until official all‑clear; waves can continue for hours.',
    'Help neighbors who may need assistance; avoid affected areas.',
  ],
  'heatwave': [
    'Limit outdoor activity 11am–4pm; take cool showers; seek AC shelters if needed.',
    'Recognize heat stroke: hot dry skin, confusion, fainting; call emergency services immediately.',
  ],
  'landslide': [
    'Evacuate immediately if a loud rumble or rapid water flow occurs; do not cross active slides.',
    'After: stay away from slide area; check for trapped/injured persons if safe.',
  ],
  'pandemic': [
    'Follow isolation/quarantine instructions; seek medical care if severe symptoms.',
    'Maintain ventilation indoors; clean high‑touch surfaces regularly.',
  ],
};