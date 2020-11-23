import bpy
import csv
import math

GimbalL = bpy.data.objects["GimbalL"]
StickL = bpy.data.objects["StickL"]
GimbalR = bpy.data.objects["GimbalR"]
StickR = bpy.data.objects["StickR"]

settings = open(bpy.path.abspath("//settings.txt"),'r').readlines()
for x in range(len(settings)):
    settings[x]=settings[x].replace('\n', '')

bpy.context.scene.render.resolution_x = int(settings[1])
bpy.context.scene.render.resolution_y = int(settings[1])/3

bpy.data.scenes["Scene"].node_tree.nodes["Math.001"].inputs[1].default_value = int(settings[2])/255.0
bpy.data.scenes["Scene"].node_tree.nodes["Math"].inputs[1].default_value = int(settings[3])/255.0
bpy.data.scenes["Scene"].node_tree.nodes["Math.002"].inputs[1].default_value = int(settings[4])/255.0
bpy.context.scene.render.fps = 1000
bpy.context.scene.render.fps_base =1000/float(settings[5])
bpy.data.scenes["Scene"].node_tree.nodes["Image"].frame_duration = int(settings[6])


csvfile = open(bpy.path.abspath("//../csv/"+settings[0]),'r')
csvFileArray = []
for row in csv.reader(csvfile, delimiter = ','):
    csvFileArray.append(row)

lengthus = (float(csvFileArray[len(csvFileArray)-1][1])-float(csvFileArray[1][1]))
lengthlist = len(csvFileArray)-1
numframes = (lengthus/1000000)*(bpy.context.scene.render.fps/bpy.context.scene.render.fps_base)
space = lengthlist/((lengthus/1000000)*(bpy.context.scene.render.fps/bpy.context.scene.render.fps_base))
scn = bpy.context.scene
scn.frame_start = 0
scn.frame_end = int(numframes+1)
def map(val,frommin,frommax,tomin,tomax):
    return ((val-frommin)/(frommax-frommin))*(tomax-tomin)+tomin



for x in range(int(numframes)):
    if(x==0):x+=1
    bpy.context.scene.frame_set(x)
    StickL.rotation_euler=[0,0,0]
    StickL.rotation_euler.rotate_axis("Y",map(float(csvFileArray[int(x*space)][15]),-500,500,0.436,-0.436))
    StickL.keyframe_insert(data_path="rotation_euler", index=-1)
    GimbalL.rotation_euler=[0,0,0]
    GimbalL.rotation_euler.rotate_axis("X",map(float(csvFileArray[int(x*space)][16]),1000,2000,0.436,-0.436))
    GimbalL.keyframe_insert(data_path="rotation_euler", index=-1)
    StickR.rotation_euler=[0,0,0]
    StickR.rotation_euler.rotate_axis("Y",map(float(csvFileArray[int(x*space)][13]),-500,500,-0.436,0.436))
    StickR.keyframe_insert(data_path="rotation_euler", index=-1)
    GimbalR.rotation_euler=[0,0,0]
    GimbalR.rotation_euler.rotate_axis("X",map(float(csvFileArray[int(x*space)][14]),-500,500,0.436,-0.436))
    GimbalR.keyframe_insert(data_path="rotation_euler", index=-1)

bpy.ops.wm.save_as_mainfile(filepath=bpy.data.filepath)