# MarkToolForParkingLotPoint
This is MATLAB GUI tool for marking parking lot point or something like that. The latest version can be found at here: https://github.com/Teoge/MarkToolForParkingLotPoint

### Requirement
MATLAB

### How to use:
#### 1. Read Image
After you have downloaded the source code, unzip it in a folder.
1. Start up MATLAB and run main.m.
2. Enter the folder your images in, or use "Choose Folder" button to select folder.
3. Select correct format of your images, and click "Read" button.
4. Click "Previous" and "Next" button, or left arrow key and right arrow key to navigate through the images.

The program will read images of corresponding format in a sequence and the total number of images will be shown below the button. The first image will be loaded automatically to the axes. The sequence and name of it will be shown below the axes.

#### 2. Mark Marks
After you have loaded an image, find parking lot points.
1. Click left mouse button on an image to mark marks.
2. Click right mouse button on a mark to delete it.
3. After marking marks, click "Save" button or "E" on the keyboard to save the marks to file.

The mark consists of a point, a circle, and an index number at the right bottom corner. Click right mouse button inside the circle to delete the mark. The marks will be save as a "mat" file with the same name of the image in the same folder. Refer to MATLAB documentation for more information about operating "mat" file.

#### 3. Mark Parking Slots
After you have marked your marks, fill the table on the right to mark parking slots.
1. Find a parking slots in the image with two parking lot points you have marked.
2. Fill the index numbers of two points in the first and second column in a row.
3. Fill the type number of the parking slots according to the type of parking slots and the sequence you fill two points.
4. Click "Save" button or "E" on the keyboard to save the parking slots to file. The slots should be drawn on the image.

There are three types of parking slots, which is defined in the parking slot detection project. Type 1 refer to the right-angle parking slots. Type 2 and 3 refer to slanted parking slots in different direction.
The following images show three types of parking slot. For each image, the parking lot point on the left hand side should be the first point you enter in the table. The parking lot point on the right hand side should be the second point you enter in the image.

| ![ParkingSlotType1](https://raw.githubusercontent.com/Teoge/MarkToolForParkingLotPoint/master/images/ParkingSlotType1.bmp) | ![ParkingSlotType2](https://raw.githubusercontent.com/Teoge/MarkToolForParkingLotPoint/master/images/ParkingSlotType2.bmp) | ![ParkingSlotType3](https://raw.githubusercontent.com/Teoge/MarkToolForParkingLotPoint/master/images/ParkingSlotType3.bmp) |
| :--------------: |:----------------:| :---------------:|
| ParkingSlotType1 | ParkingSlotType2 | ParkingSlotType3 |

#### Advanced Functionality
1. Press "F" key on the keyboard to magnify to a nearby region of mouse position.
2. Press "W", "A", "S" and "D" keys on the keyboard to fine tune the position of certain mark. By default, it is the last mark your have marked, namely the mark with largest index number. But when you magnify the image, the mark you fine tune will be the mark in the view with smallest index number.
3. Use mouse wheel up and down to perform "Save" + "Previous" button function and "Save" + "Next" button function.
