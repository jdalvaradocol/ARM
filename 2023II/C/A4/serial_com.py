import os
import io
import serial
import numpy as  np
import matplotlib.pyplot as plt
from   matplotlib.animation import FuncAnimation

serial_data =("COM5","serial")
data = serial.Serial(port=serial_data[0],baudrate=460800,timeout=None)

inicio = 0
n = 2
valor = 0
i = 0
adc = 0
signal = np.zeros(100)

while(True):
    dato = data.read()
    integer = int.from_bytes(dato, byteorder='little', signed=True)
    
    # print("Dato = ", dato)  

    if (dato == b')'):
        inicio = 0

        index =  int(valor / 100000)
        adc =  int(valor % 100000)

        signal[index] = adc

        #print(" adc = ", adc," index = ", index)  

        if(index > 98):
            print(" data ",signal )  

    if  (inicio == 1):
        valor = valor + (integer - 48) * (10**n)
        n = n - 1
    elif (inicio == 0):
        n = 8
        valor = 0

    if  (dato == b'('):
        inicio = 1
        i= i+1
     
    