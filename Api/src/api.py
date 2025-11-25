from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import joblib
import pandas as pd
import uvicorn
import os
import tensorflow as tf
from contextlib import asynccontextmanager

# --- CONFIGURATION ---
BASE_DIR = os.path.dirname(os.path.dirname(__file__))
MODELS_DIR = os.path.join(BASE_DIR, 'models')
MODEL1_PATH = os.path.join(MODELS_DIR, 'model1.keras')
MODEL2_PATH = os.path.join(MODELS_DIR, 'model2.keras')
PREPROCESSOR_PATH = os.path.join(MODELS_DIR, 'preprocessor.joblib')

# --- GLOBAL STATE ---
models = {}

# --- LIFESPAN MANAGER ---
@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    Load models on startup and clean up on shutdown.
    """
    try:
        if os.path.exists(MODEL1_PATH) and os.path.exists(MODEL2_PATH) and os.path.exists(PREPROCESSOR_PATH):
            print("Loading models and preprocessor...")
            models["model1"] = tf.keras.models.load_model(MODEL1_PATH)
            models["model2"] = tf.keras.models.load_model(MODEL2_PATH)
            models["preprocessor"] = joblib.load(PREPROCESSOR_PATH)
            print("Models loaded successfully!")
        else:
            print("WARNING: Models not found. Please run training script first.")
    except Exception as e:
        print(f"Error loading models: {e}")
    
    yield
    
    # Cleanup (if needed)
    models.clear()

# --- APP INITIALIZATION ---
app = FastAPI(title="Diamonds Price Prediction API", lifespan=lifespan)

# --- DATA MODELS ---
class DiamondInput(BaseModel):
    carat: float
    cut: str
    color: str
    clarity: str
    depth: float
    table: float
    x: float
    y: float
    z: float

# --- ROUTES ---
@app.get("/")
def read_root():
    return {"message": "Diamonds Price Prediction API is online!"}

@app.post("/predict")
def predict_price(data: DiamondInput):
    if not models.get("model1") or not models.get("model2") or not models.get("preprocessor"):
        raise HTTPException(status_code=503, detail="Models not loaded. Service unavailable.")
    
    try:
        # Prepare input
        input_df = pd.DataFrame([data.dict()])
        
        # Preprocess
        processed_data = models["preprocessor"].transform(input_df)
        
        # Predict
        pred1 = models["model1"].predict(processed_data).flatten()[0]
        pred2 = models["model2"].predict(processed_data).flatten()[0]
        
        # Ensemble (Simple Average)
        final_prediction = (pred1 + pred2) / 2
        
        return {
            "predicted_price": float(final_prediction),
            "details": {
                "model1": float(pred1),
                "model2": float(pred2)
            },
            "input": data.dict()
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Prediction error: {str(e)}")

if __name__ == "__main__":
    # Add current directory to path to allow running directly
    import sys
    sys.path.append(os.path.dirname(__file__))
    uvicorn.run("api:app", host="0.0.0.0", port=8005, reload=True)
