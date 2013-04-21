import nxt.locator
from time import sleep
from nxt.motor import *

FREQ_E = 659
FREQ_G = 784

def move_forward(b, speed, distance):
    sleep(1.0)

def run(b, duration):
	rw = Motor(b, PORT_A)
	lw = Motor(b, PORT_B)
	ww = SynchronizedMotors(rw, lw, 2)
	ww.run()
	sleep(duration)
	ww.idle()
	ww.brake()


def turn(b, right, distance):
	if right == 1:
		w = Motor(b, PORT_A)
	else:
		w = Motor(b, PORT_B)
	w.turn(20, distance)


b = nxt.locator.find_one_brick(name = 'William')
run(b, 0.5)
'''
turn(b, 1, 45)
move_forward(b, 20, 90)
b.play_tone_and_wait(FREQ_E, 500)
b.play_tone_and_wait(FREQ_G, 500)
turn(b, 0, 45)
move_forward(b, 20, 90)
'''