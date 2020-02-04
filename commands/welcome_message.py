from datetime import datetime

now = datetime.now()

FRENCH = {
    "morning": "Bonjour, Monsieur",
    "evening": "Bonsoir, Monsieur"
}

GERMAN = {
    "afternoon": "Guten Tag, Herr Ponti"
}

if now.hour < 12:
    print(FRENCH["morning"])
elif now.hour > 12 and now.hour < 17:
    print(GERMAN["afternoon"])
else:
    print(FRENCH["evening"])
