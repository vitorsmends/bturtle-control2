import pandas as pd

input_file = 'cmd_vel.csv'
output_file = 'cmd_vel_clean.csv'

# Função para extrair os valores de 'x' da coluna 'linear'
def extract_values(row):
    linear_data = eval(row['linear'])  # Avalia a string como um dicionário Python
    return linear_data['x']

# Ler o arquivo CSV
df = pd.read_csv(input_file)

# Extrair os valores de 'x' da coluna 'linear'
df['linear'] = df.apply(extract_values, axis=1)
x_values = df['linear'].tolist()

# Criar um novo DataFrame apenas com os valores de 'x'
new_df = pd.DataFrame({'x': x_values})

# Exportar para um novo arquivo CSV
new_df.to_csv(output_file, index=False)
