import csv
import numpy as np
from scipy.spatial.transform import Rotation

input_file = 'imu.csv'
output_file = 'imu_clean.csv'

with open(input_file, 'r') as file:
    csv_reader = csv.DictReader(file)
    headers = ['row']
    rows = []

    for row in csv_reader:
        orientation = eval(row['orientation'])
        x = orientation['x']
        y = orientation['y']
        z = orientation['z']
        w = orientation['w']

        # Crie um objeto de rotação usando o quaternion
        quaternion = [w, x, y, z]
        rotation = Rotation.from_quat(quaternion)

        # Converta para ângulos de Euler (convenção ZYX)
        euler_angles = rotation.as_euler('ZYX', degrees=True)

        # Obtendo o valor "row" correspondente aos ângulos de Euler
        row_value = euler_angles[0]

        # Adicione o valor "row" à lista
        rows.append([row_value])

    with open(output_file, 'w', newline='') as outfile:
        csv_writer = csv.writer(outfile)
        csv_writer.writerow(headers)
        csv_writer.writerows(rows)

print("Dados extraídos e salvos com sucesso no arquivo 'imu_clean.csv'.")
