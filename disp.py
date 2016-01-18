#!usr/bin/python
#
# Author Ben Allen

import pygame, sys, os, math
from pygame.locals import *
import time

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

# main game loop
def main():
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

    logo = pygame.image.load("logo.jpg").convert()
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
    print "."

# Run Main Function
if __name__ == '__main__':
    main()