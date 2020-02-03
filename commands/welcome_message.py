from datetime import datetime

now = datetime.now()

if now.hour < 12:
  print("Bonjour, Monsieur")
elif now.how > 12 and now.hour < 17:
  print("Bonjour, Monsieur")
else:
  print("Bonsoir, Monsieur")
