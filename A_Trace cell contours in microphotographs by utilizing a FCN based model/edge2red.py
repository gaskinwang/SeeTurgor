# -*- coding: utf-8 -*-
"""

"""
#Preprocess the training data to convert the non-black portion of images to red, i.e., unify all label lines to same color
import os
from PIL import Image


List = []
width=131
height=87

def ResizeImage(filein,width, height):
  img = Image.open(filein)
  fileout = '/home/wangjun/DeepLearning/yanglei/KittiSeg/DATA/data_road/training/gt_image_3/' + filein[-13:-1] + 'g'
  for i in range(131):
      for j in range(87):
          r,g,b = img.getpixel((i,j))
          if (r == 0 and g ==0 and b == 0):
              c=0
          else:
              r,g,b = 255,0,0
              img.putpixel((i,j),(r,g,b))
        #resize image with high-quality
  img.save(fileout)


def GetFileList(dir, fileList):
    newDir = dir
    if os.path.isfile(dir):
        fileList.append(dir)
    elif os.path.isdir(dir):  
        for s in os.listdir(dir):
            #If you need to ignore certain folders, use the following code
            #if s == "xxx":
                #continue
            newDir=os.path.join(dir,s)
            newDir=('/').join(newDir.split('\\'))
            GetFileList(newDir, fileList)  
    return fileList

file_list = GetFileList('/home/wangjun/DeepLearning/yanglei/KittiSeg/DATA/data_road/training/gt_image_2',[])
for file in file_list:
    print('g')
    ResizeImage(file,width,height)