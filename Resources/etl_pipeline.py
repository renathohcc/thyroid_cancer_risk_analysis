import pandas as pd
from sqlalchemy import create_engine

# Carregar o arquivo CSV
file_path = 'thyroid_cancer_risk_data.csv'
df = pd.read_csv(file_path)

# Tratamentos dos dados
# 1. Remover duplicatas
print(f"Linhas antes da remoção de duplicatas: {len(df)}")
df = df.drop_duplicates(subset='Patient_ID')
print(f"Linhas após a remoção de duplicatas: {len(df)}")

# 2. Padronizar textos
cols_to_strip = ['Gender', 'Country', 'Ethnicity', 'Family_History', 'Radiation_Exposure',
                 'Iodine_Deficiency', 'Smoking', 'Obesity', 'Diabetes', 'Thyroid_Cancer_Risk', 'Diagnosis']
df[cols_to_strip] = df[cols_to_strip].apply(lambda x: x.str.strip().str.lower())

# 3. Converter Yes/No para Y/N
yes_no_cols = ['Family_History', 'Radiation_Exposure', 'Iodine_Deficiency', 'Smoking', 'Obesity', 'Diabetes']
df[yes_no_cols] = df[yes_no_cols].replace({'yes': 'y', 'no': 'n'})

# 4. Verificar valores ausentes
df.fillna({'TSH_Level': 0.0, 'T3_Level': 0.0, 'T4_Level': 0.0, 'Nodule_Size': 0.0}, inplace=True)

# 5. Configurar tipos de dados
df = df.astype({
    'Patient_ID': 'int64',
    'Age': 'int64',
    'TSH_Level': 'float64',
    'T3_Level': 'float64',
    'T4_Level': 'float64',
    'Nodule_Size': 'float64'
})

# Conexão com o banco MySQL
user = 'root'
password = 'hopt1234'
host = 'localhost'
database = 'thyroid'
engine = create_engine(f'mysql+pymysql://{user}:{password}@{host}/{database}')

# Importar os dados para o MySQL
df.to_sql('thyroid_cancer_data', con=engine, if_exists='replace', index=False)

print("Dados importados com sucesso!")