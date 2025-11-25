from fastapi.testclient import TestClient
from src.api import app
import json
import sys
import os

# Adicionar diretório atual ao path
sys.path.append(os.path.dirname(__file__))

client = TestClient(app)

def test_read_root():
    with TestClient(app) as client:
        response = client.get("/")
        assert response.status_code == 200
        assert response.json() == {"message": "Diamonds Price Prediction API is online!"}
        print("Teste Root: OK")

def test_predict():
    payload = {
        "carat": 1.0,
        "cut": "Ideal",
        "color": "E",
        "clarity": "VS1",
        "depth": 61.5,
        "table": 55.0,
        "x": 6.5,
        "y": 6.5,
        "z": 4.0
    }
    
    with TestClient(app) as client:
        response = client.post("/predict", json=payload)
        if response.status_code != 200:
            print(f"Error Response: {response.text}")
        assert response.status_code == 200
        data = response.json()
        
        print(f"Status Code: {response.status_code}")
        print(f"Resposta: {json.dumps(data, indent=2)}")
        
        assert "predicted_price" in data
        assert "details" in data
        assert isinstance(data["predicted_price"], float)
        print("Teste Predict: OK")

if __name__ == "__main__":
    print("Iniciando testes...")
    test_read_root()
    test_predict()
    print("Todos os testes passaram!")
