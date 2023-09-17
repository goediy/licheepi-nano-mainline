Python LCD clock example

Setup
-----
1) download LCD driver
$ curl -Ok https://raw.githubusercontent.com/sterlingbeason/LCD-1602-I2C/master/LCD.py

2) check the I2C address of LCD
$ i2cdetect -y 0

3) edit lcdclock.py along with I2C address of your device
$ em lcdclock.py


Running program
---------------
$ python lcdclock.py

