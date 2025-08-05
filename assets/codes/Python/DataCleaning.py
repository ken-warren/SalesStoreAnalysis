import pandas as pd

# Load data
df = pd.read_csv("orders_raw.csv", encoding='utf-8')

# Convert dates to proper format
df['OrderDate'] = pd.to_datetime(df['OrderDate'], errors='coerce')
df['BirthDate'] = pd.to_datetime(df['BirthDate'], errors='coerce')

# Strip leading/trailing whitespace
df = df.applymap(lambda x: x.strip() if isinstance(x, str) else x)

# Ensure numerical types
df['Quantity'] = pd.to_numeric(df['Quantity'], errors='coerce')
df['Price'] = pd.to_numeric(df['Price'], errors='coerce')

# Save cleaned version
df.to_csv("orders_cleaned.csv", index=False)
