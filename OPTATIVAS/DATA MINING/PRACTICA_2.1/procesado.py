import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Carga el conjunto de datos
df = pd.read_csv('WineQT.csv')

# Resumen estadístico
print(df.describe())

# Verificación de valores nulos
print(df.isnull().sum())

# Verificación de tipos de datos
print(df.dtypes)

# Histogramas para todas las columnas
df.hist(bins=50, figsize=(20,15))
plt.show()

# Diagramas de caja y bigotes para todas las columnas
plt.figure(figsize=(20,10))
df.boxplot(vert=0)
plt.show()

# Matriz de correlación
corr_matrix = df.corr()
sns.heatmap(corr_matrix, annot=True)
plt.show()
print(corr_matrix)

