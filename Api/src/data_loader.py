import pandas as pd
import seaborn as sns
import os
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.compose import ColumnTransformer
from sklearn.model_selection import train_test_split
import joblib

def load_data(filepath="data/diamonds.csv"):
    """
    Loads the diamonds dataset. Tries to load from CSV first,
    falls back to seaborn if file not found.
    """
    if os.path.exists(filepath):
        print(f"Loading data from {filepath}")
        return pd.read_csv(filepath)
    
    print("CSV not found, loading from seaborn...")
    return sns.load_dataset('diamonds')

def preprocess_data(df):
    """
    Preprocesses the diamonds dataset:
    - Separates features (X) and target (y).
    - Encodes categorical variables (cut, color, clarity).
    - Scales numerical variables.
    - Returns X_train, X_test, y_train, y_test and the preprocessor.
    """
    y = df['price']
    X = df.drop('price', axis=1)
    
    categorical_cols = ['cut', 'color', 'clarity']
    numerical_cols = ['carat', 'depth', 'table', 'x', 'y', 'z']
    
    preprocessor = ColumnTransformer(
        transformers=[
            ('num', StandardScaler(), numerical_cols),
            ('cat', OneHotEncoder(handle_unknown='ignore', sparse_output=False), categorical_cols)
        ]
    )
    
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    
    X_train_processed = preprocessor.fit_transform(X_train)
    X_test_processed = preprocessor.transform(X_test)
    
    return X_train_processed, X_test_processed, y_train, y_test, preprocessor

def save_preprocessor(preprocessor, filepath="models/preprocessor.joblib"):
    joblib.dump(preprocessor, filepath)

def load_preprocessor(filepath="models/preprocessor.joblib"):
    return joblib.load(filepath)
