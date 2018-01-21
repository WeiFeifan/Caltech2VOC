import shutil
import os
annotations='test/annotations'
imagepath='test/OImages/'
distimages= 'test/images/'
def movePicture():
	for walk in os.walk(annotations):
		for each in walk[2]:
			pictureName=each.replace('.xml','.jpg')
			imgFile=imagepath + pictureName
			distFile=distimages+pictureName
			shutil.copyfile(imgFile,distFile)
			print imgFile
if __name__=="__main__":
	movePicture()