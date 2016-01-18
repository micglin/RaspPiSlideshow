#!/usr/bin/python
#
# Author Ben Allen

import pygame, sys, os, math
from pygame.locals import *
import time
from os import listdir
from os.path import isfile, join
import string

# Set the display to fb1 - i.e. the TFT
os.environ["SDL_FBDEV"] = "/dev/fb0"
# Remove mouse
os.environ["SDL_NOMOUSE"]="1"

# Set constants
FPS=1000
DISPLAY_H=240 # 120 for 1.8"
DISPLAY_W=320 # 168 for 1.8"
BLACK = (  0,   0,   0)
WHITE = (255, 255, 255)
RED   = (255,   0,   0)
GREEN = (  0, 255,   0)
BLUE  = (  0,   0, 255)
IRED  = (176,  23,  21)
SLIDES_DIR = "/var/media/current/"
LOGOS_DIR =  "/var/media/logos/"
DATA_DIR =  "/var/media/data/"

update_slide = 10
update_text1 = 1     
update_text2 = 1
update_logo = 60
update_weather = 900
update_stocks = 900

line1 = ["Welcome here!", "Welcome two!"]
line2 = ["Have a nice day!", "Visit the tech hub!", "There will be cake at the end of the day"]

# main game loop
def main():
    now = time.time()
    
    screen = None;

    "Ininitializes a new pygame screen using the framebuffer"
    disp_no = os.getenv("DISPLAY")
    if disp_no:
        print "I'm running under X display = {0}".format(disp_no)

    # Check which frame buffer drivers are available
    # Start with fbcon since directfb hangs with composite output
    drivers = ['fbcon', 'directfb', 'svgalib']
    found = False
    for driver in drivers:
        # Make sure that SDL_VIDEODRIVER is set
        if not os.getenv('SDL_VIDEODRIVER'):
            os.putenv('SDL_VIDEODRIVER', driver)
        try:
            print 'Driver: {0} Success.'.format(driver)
            pygame.display.init()
        except pygame.error:
            print 'Driver: {0} failed.'.format(driver)
            continue
        found = True
        break

    global FPSCLOCK, DISPLAYSURF, DISPLAY_W, DISPLAY_H
    global slide_num, last_slide, last_text1, last_text2, last_logo, line1_num, line2_num
    
    last_slide = now
    last_text1 = now   
    last_text2 = now
    last_logo = now

    slide_num = 0
    line1_num = 0
    line2_num = 0

    FPSCLOCK = pygame.time.Clock()
    size = (pygame.display.Info().current_w, pygame.display.Info().current_h)
    DISPLAY_W = pygame.display.Info().current_w
    DISPLAY_H = pygame.display.Info().current_h

    print "Framebuffer size: %d x %d" % (size[0], size[1])
    DISPLAYSURF=pygame.display.set_mode(size, pygame.FULLSCREEN, 32)
    pygame.mouse.set_visible(0)
    pygame.font.init()

    print "Showing logo."
    dispLogo()
    pygame.display.update()

    time.sleep(2)

    print "Running main loop."

    while True:
        for event in pygame.event.get():
            if event.type ==  QUIT or (event.type == KEYUP and event.key == K_ESCAPE):
                pygame.quit()
                sys.exit()
  
        mainLoop()
        pygame.display.update()
        FPSCLOCK.tick(FPS)
        time.sleep(2)


# a funtion to do something
def dispLogo():
    DISPLAYSURF.fill(BLACK)

    logo = pygame.image.load("/var/media/bg.jpg").convert()
    logo2 = pygame.transform.scale(logo, (DISPLAY_W, DISPLAY_H))
    DISPLAYSURF.blit(logo2, (0,0))

    pygame.draw.arc(DISPLAYSURF, RED, ((DISPLAY_W/2-40, DISPLAY_H/2-90), (80,80)), math.pi/4, math.pi, 10)
    pygame.draw.arc(DISPLAYSURF, IRED, ((DISPLAY_W/2-40, DISPLAY_H/2-80), (80,80)), math.pi/4, math.pi, 10)
    pygame.draw.arc(DISPLAYSURF, RED, ((DISPLAY_W/2-40, DISPLAY_H/2-70), (80,80)), math.pi/4, math.pi, 10)

    fontObj = pygame.font.Font('freesansbold.ttf', 80)

    textSurfaceObj = fontObj.render('OBMetrics', True, BLACK)
    textRectObj = textSurfaceObj.get_rect()

    textRectObj.center = (DISPLAY_W/2,DISPLAY_H/2+20+1)
    DISPLAYSURF.blit (textSurfaceObj, textRectObj)

    textRectObj.center = (DISPLAY_W/2+1,DISPLAY_H/2+20-1)
    DISPLAYSURF.blit (textSurfaceObj, textRectObj)

    textRectObj.center = (DISPLAY_W/2+1,DISPLAY_H/2+20)
    DISPLAYSURF.blit (textSurfaceObj, textRectObj)

    textRectObj.center = (DISPLAY_W/2-1,DISPLAY_H/2+20)
    DISPLAYSURF.blit (textSurfaceObj, textRectObj)

    textSurfaceObj = fontObj.render('OBMetrics', True, WHITE)
    textRectObj = textSurfaceObj.get_rect()

    textRectObj.center = (DISPLAY_W/2,DISPLAY_H/2+20)
    DISPLAYSURF.blit (textSurfaceObj, textRectObj)

def mainLoop():
    global slide_num, last_slide, last_text1, last_text2, last_logo, line1_num, line2_num
    now = time.time()
    
    DISPLAYSURF.fill((0, 0, 0))
    bg = pygame.image.load('/var/media/bg.jpg').convert()
    DISPLAYSURF.blit(bg, (0, 500))
    
    borderColor = (255, 255, 255)
    lineColor = (64, 64, 64)

    s1w = 1541
    s1h = 869
    so = 5
    pygame.draw.rect(DISPLAYSURF, borderColor, (so,so,s1w,s1h), 1)
    pygame.draw.rect(DISPLAYSURF, borderColor, (2*so+s1w,so,364,131), 1)
    pygame.draw.rect(DISPLAYSURF, borderColor, (2*so+s1w,141,364,364), 1)
    pygame.draw.rect(DISPLAYSURF, borderColor, (2*so+s1w,510,364,364), 1)
    pygame.draw.rect(DISPLAYSURF, RED, (0,0,1920-1,1080-1), 1)

    # Display Slides
    slides = [f for f in listdir(SLIDES_DIR) if isfile(join(SLIDES_DIR, f))]

    if slide_num >= len(slides):
      slide_num=0;

    slide = pygame.image.load(SLIDES_DIR+slides[slide_num]).convert()
    slide2 = pygame.transform.scale(slide, (s1w-2, s1h-2))
    DISPLAYSURF.blit(slide2, (6, 6))
    if now-last_slide > update_slide:
      last_slide = now
      slide_num = slide_num+1

    # Draw Text Ticker
    if line1_num>=len(line1):
      line1_num=0;

    font = pygame.font.SysFont("liberationsans", 100)
    text_surface = font.render(line1[line1_num], 
      True, (255, 255, 200))
    DISPLAYSURF.blit(text_surface, (5, 880))
    if now-last_text1 > update_text1:
      last_text1 = now
      line1_num = line1_num+1

    if line2_num>=len(line2):
      line2_num=0;

    font = pygame.font.Font(None, 70)
    text_surface = font.render(line2[line2_num], 
      True, (255, 255, 200))
    DISPLAYSURF.blit(text_surface, (5, 980))
    if now-last_text2 > update_text2:
      last_text2 = now
      line2_num = line2_num+1

    # Display Logo
    logos = [f for f in listdir(LOGOS_DIR) if isfile(join(LOGOS_DIR, f))]

    if logo_num>=len(logos):
      logo_num=0;

    logo = pygame.image.load(LOGOS_DIR+logos[logo_num]).convert()
    logo2 = pygame.transform.scale(logo, (362,129))
    DISPLAYSURF.blit(logo2, (2*so+s1w+1,so+1))
    if now-last_logo > update_logo:
       last_logo = now
       w_num = w_num+1

    print "."

# Run Main Function
if __name__ == '__main__':
    main()

