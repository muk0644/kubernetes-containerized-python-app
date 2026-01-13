import time
import pandas as pd
import numpy as np
from datetime import datetime

# Second container - processes data using pandas
while True:
    # Create sample data and process it with pandas
    data = {
        'timestamp': [datetime.now().strftime("%Y-%m-%d %H:%M:%S")],
        'values': [np.random.randint(1, 100)],
        'status': ['Active']
    }
    df = pd.DataFrame(data)
    
    current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"[{current_time}] Container 2: Processing data...")
    print(f"[{current_time}] Mean value: {df['values'].mean()}")
    print(f"[{current_time}] Status: Service running successfully")
    time.sleep(7)
