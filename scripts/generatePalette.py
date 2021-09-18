
from PIL import Image

def add_pixel(palette, color):
  palette.append(color)

def add_pixels(palette, color1, color2, steps):
  for n in range(steps):
    #print(n)
    part = n/(steps-1)
    color = [0,0,0,255]
    for c in range(3):
      color[c] = int(color1[c]+(color2[c]-color1[c])*part)
    palette.append(tuple(color))

img = Image.new(mode="RGBA",size=(16,16),color=(0,0,0,255));
#add_pixels(palette, (38,127,0,255), (48,48,48,255), 256)
#add_pixels(palette, (131,106,88,255), (38,127,0,255), 128)
#add_pixels(palette, (38,127,0,255), (48,48,48,255), 128)
help_colors = []
add_pixels(help_colors, (38,127,0,255), (131,106,88,255), 16)
palette = []
for i in range(16):
  add_pixels(palette, help_colors[i], (48,48,48,255), 16)
img.putdata(palette)
img.save("composting_composter_palette.png")

img = Image.new(mode="RGBA",size=(16,16),color=(0,0,0,255));
palette = []
add_pixels(palette, (106,75,49,255), (70,40,10,255), 256)
img.putdata(palette)
img.save("composting_garden_soil_palette.png")
