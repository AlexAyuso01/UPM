import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt



# Cargar el conjunto de datos
data = pd.read_csv('diabetes.csv')

# Verificar los nombres de las columnas
print(data.columns)

# Reemplazar ceros por NaN en las columnas específicas
cols = ['Glucose','BloodPressure', 'SkinThickness', 'Insulin', 'BMI']
data[cols] = data[cols].replace({0:np.nan})

# Calcular la matriz de correlación
corr_matrix = data.corr()
sns.heatmap(corr_matrix, annot=True)
plt.show()
# Imprimir la matriz de correlación
print(corr_matrix)

# Guardar el conjunto de datos procesado
data.to_csv('pima-indians-diabetes-processed.csv', index=False)


