from tensorflow import keras
from tensorflow.keras import layers
from data_loader import load_data, preprocess_data, save_preprocessor
import numpy as np
import os

def create_model_1(input_shape):
    """
    Model 1: Simple MLP
    """
    model = keras.Sequential([
        layers.Dense(64, activation='relu', input_shape=[input_shape]),
        layers.Dense(32, activation='relu'),
        layers.Dense(1)
    ])
    
    model.compile(
        optimizer='adam',
        loss='mae',
        metrics=['mae', 'mse']
    )
    return model

def create_model_2(input_shape):
    """
    Model 2: Deeper MLP with Dropout
    """
    model = keras.Sequential([
        layers.Dense(128, activation='relu', input_shape=[input_shape]),
        layers.Dropout(0.2),
        layers.Dense(64, activation='relu'),
        layers.Dense(32, activation='relu'),
        layers.Dense(1)
    ])
    
    model.compile(
        optimizer='adam',
        loss='mae',
        metrics=['mae', 'mse']
    )
    return model

def main():
    # Load and preprocess data
    print("Loading and preprocessing data...")
    df = load_data()
    X_train, X_test, y_train, y_test, preprocessor = preprocess_data(df)
    
    input_shape = X_train.shape[1]
    
    # Train Model 1
    print("\nTraining Model 1 (Simple MLP)...")
    model1 = create_model_1(input_shape)
    history1 = model1.fit(
        X_train, y_train,
        validation_split=0.2,
        batch_size=32,
        epochs=50,
        verbose=1
    )
    
    # Train Model 2
    print("\nTraining Model 2 (Deeper MLP)...")
    model2 = create_model_2(input_shape)
    history2 = model2.fit(
        X_train, y_train,
        validation_split=0.2,
        batch_size=32,
        epochs=50,
        verbose=1
    )
    
    # Evaluate
    print("\nEvaluating Models...")
    loss1, mae1, mse1 = model1.evaluate(X_test, y_test, verbose=0)
    loss2, mae2, mse2 = model2.evaluate(X_test, y_test, verbose=0)
    
    print(f"Model 1 MAE: {mae1:.2f}")
    print(f"Model 2 MAE: {mae2:.2f}")
    
    # Voting (Averaging)
    print("\nEvaluating Voting Ensemble...")
    pred1 = model1.predict(X_test).flatten()
    pred2 = model2.predict(X_test).flatten()
    pred_voting = (pred1 + pred2) / 2
    
    mae_voting = np.mean(np.abs(y_test - pred_voting))
    print(f"Voting Ensemble MAE: {mae_voting:.2f}")
    
    # Save models
    if not os.path.exists('models'):
        os.makedirs('models')
        
    print("\nSaving models...")
    model1.save("models/model1.keras")
    model2.save("models/model2.keras")
    save_preprocessor(preprocessor, "models/preprocessor.joblib")
    print("Models and preprocessor saved successfully.")

if __name__ == "__main__":
    main()
