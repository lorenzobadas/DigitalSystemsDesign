# Interaction via SPI with accelerometer ADXL362 on the Digilent Nexys A7 board
## Description
The goal is to display the accelerations of the `x`, `y` and `z` axis detected by the accelerometer on the 8 seven-segment displays on the board.  
To do this we have to implement a FSM to communicate with the accelerometer via SPI paying particular attention to the timings in the datasheet.
