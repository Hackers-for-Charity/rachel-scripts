import os

def dirs(MyDir):
  if os.path.isdir(MyDir):
    for f in os.listdir(MyDir):
      fullname = os.path.join(MyDir,f)
      ext = os.path.splitext(f)[1]
      if os.path.isfile(fullname):
        if ext == ".mp4":
          newname = os.path.join("/var/ka-lite/content",f)
          if not os.path.exists(newname):
            print newname
            os.system("sudo cp " + fullname + " " + newname)
  return

if __name__ == "__main__":
  import sys
  if len(sys.argv) > 1:
    dirs(sys.argv[1])
  else:
    dirs("/home/pi/nas/RPi/ka-lite-content-resized/content")

  
