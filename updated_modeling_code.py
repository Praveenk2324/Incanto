# 1. Import necessary components
from sklearn.model_selection import GridSearchCV
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import PoissonRegressor
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score

# 2. Re-define the alternative model - PoissonRegressor (Great for Count Data)
poisson_model = Pipeline([
    ('scaler', StandardScaler()),
    ('regressor', PoissonRegressor())
])

# 3. Define hyperparameter grid for GridSearchCV
param_grid = {
    'regressor__alpha': [1e-4, 1e-3, 1e-2, 0.1, 1.0, 10.0],
    'regressor__max_iter': [100, 300, 500]
}

# 4. Initialize GridSearchCV for cross-validation
grid_search = GridSearchCV(
    estimator=poisson_model,
    param_grid=param_grid,
    cv=5, # 5-fold cross-validation
    scoring='neg_mean_squared_error',
    n_jobs=-1,
    verbose=1
)

# 5. Fit the model to find the best hyperparameters
grid_search.fit(X_train, y_train)

# 6. Extract the best model based on CV
best_model = grid_search.best_estimator_

print(f"Best Hyperparameters: {grid_search.best_params_}")

# 7. Evaluate the best model on the test set
y_pred = best_model.predict(X_test)
mse = mean_squared_error(y_test, y_pred)
mae = mean_absolute_error(y_test, y_pred)
r2 = r2_score(y_test, y_pred)

print(f"\\nEvaluation Metrics on Test Set:")
print(f"Mean Squared Error (MSE): {mse:.2f}")
print(f"Mean Absolute Error (MAE): {mae:.2f}")
print(f"R-squared (R2): {r2:.2f}")

# Optional: To understand which features had the most impact
coefficients = best_model.named_steps['regressor'].coef_
feature_importance_df = pd.DataFrame({
    'Feature': features,
    'Coefficient': coefficients
}).sort_values(by='Coefficient', key=abs, ascending=False)

print("\\nFeature Coefficients (Impact on DefectCount):")
print(feature_importance_df)
