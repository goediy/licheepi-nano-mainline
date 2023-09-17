# Copyright (c) Goediy All rights reserved.
# Licensed under the MIT License. See LICENSE in the project root
# for license information.
from LCD import LCD
from time import sleep, localtime, mktime
 
DEFAULT_I2C_ADDR = 0x27
 
# 曜日
daysOfTheWeek = "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"
 
def lcdclock_main():
    lcd = LCD(1, DEFAULT_I2C_ADDR)
 
    lcd.message("LCD Clock", 1)
    lcd.message("Now Booting...", 2)

    sleep(1)
 
    lcd.message("", 1)
    while True:
        tm = localtime(mktime(localtime()))
 
        datestr = "%4d/%02d/%02d" % (tm[0:3])
        datestr += "(" + daysOfTheWeek[tm[6]] + ")"
        lcd.message(datestr)
        lcd.message("%2d:%02d:%02d" % (tm[3:6]), 2)
        sleep(1)
 
 
if __name__ == "__main__":
    lcdclock_main()
