# -*- coding: utf-8 -*-


import os
from PIL import Image
import scipy as scp


height=87

def ColorImage(filein):
    img = Image.open(filein).convert('LA')
    if not os.path.isdir('E:\\imgfile\\demo'):#your path
        os.mkdir('E:\\imgfile\\demo')
        print('Successful mkdir ' + 'demo')
    fileout = 'E:\\imgfile\\demo\\' + filein[-7:-1] + 'g'
    img = img.convert('RGB')
    #image = scp.misc.imread(input_image)
    #img = img[:, :, 0:3]
    img.save(fileout)
    print('Successful processing of pictures, to ' + fileout)



def GetFileList(dir, fileList):
    newDir = dir
    if os.path.isfile(dir):
        fileList.append(dir)
    elif os.path.isdir(dir):  
        for s in os.listdir(dir):
            newDir=os.path.join(dir,s)
            #newDir=('/').join(newDir.split('\\'))
            GetFileList(newDir, fileList)  
    return fileList

file_list = GetFileList('E:\\imgfile\\',[])
print(file_list)

for file in file_list:
    ColorImage(file)