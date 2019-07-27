# MarkToolForParkingLotPoint
This is MATLAB GUI tool for marking parking lot point or something like that. The latest version can be found at here: https://github.com/Teoge/MarkToolForParkingLotPoint

### Requirement
MATLAB (In windows, please set your display setting to 100% to fully display the GUI.)
For small screen in notebook, use the fig file in folder "SmallScreenUI" instead. (Replace the `main.fig` in root folder with the `main.fig` in "SmallScrennUI")

### How to use:
#### 1. Read Image
Clone or download the source.
1. Start up MATLAB and run main.m.
2. Enter the folder your images in, or use "Choose Folder" button to select folder.
3. Select correct format of your images, and click "Read" button.
4. Use "Previous" and "Next" button, or left arrow key and right arrow key to navigate through the images.

The program will read images of corresponding format in a sequence and the total number of images will be shown below the "read" button. The first image will be loaded automatically. The sequence number and name of it will be shown below the figure.

#### 2. Mark Marks
After you have loaded an image, find parking-slot marking-points.
1. Click left mouse button on an image to mark marks.
2. Click right mouse button on a mark to delete it.
3. After marking marks, click "Save" button or "F" on the keyboard to save the marks to file.

The mark consists of a point, a circle, and an index number at the right bottom corner. Click right mouse button inside the circle to delete the mark. The marks will be save as a "mat" file with the same name of the image in the same folder. Refer to MATLAB documentation for more information about operating "mat" file.

#### 3. Mark Parking Slots
After you have marked your marks, fill the table on the right to mark parking slots.
1. Find a parking slots in the image with two markinhg-points you have marked.
2. Fill the index numbers of two points in the first and second column in a row.
3. Fill the type number of the parking slots according to the type of parking-slots and the sequence you fill two points.
4. Fill the angle of parking slots in degree form. For vertical slots as type 1, you should fill in 90. For slanted slots as type 2, you should fill in a degree less than 90. For slanted slots as type 3, you should fill in a degree more than 90.
5. Click "Save" button or "F" on the keyboard to save the parking slots to file.

Parking slots are divided into three types, which is defined by us. Type 1 refer to the right-angle parking slots. Type 2 and 3 refer to slanted parking slots in different direction.

The following images show three types of parking slot. For each image, the marking-point on the left hand side should be the first point you enter in the table. The marking-point on the right hand side should be the second point you enter in the image.

| ![ParkingSlotType1](https://raw.githubusercontent.com/Teoge/MarkToolForParkingLotPoint/master/images/ParkingSlotType1.bmp) | ![ParkingSlotType2](https://raw.githubusercontent.com/Teoge/MarkToolForParkingLotPoint/master/images/ParkingSlotType2.bmp) | ![ParkingSlotType3](https://raw.githubusercontent.com/Teoge/MarkToolForParkingLotPoint/master/images/ParkingSlotType3.bmp) |
| :--------------: | :--------------: | :--------------: |
| ParkingSlotType1 | ParkingSlotType2 | ParkingSlotType3 |

#### Advanced Functionality
1. Click left mouse button without releasing to drag a mark.
2. Use mouse scroll wheel to zone in and zone out of the figure. When in the zone in mode, use left mouse button to drag across the image, while the ability of creating marks with left mouse button is disable.
3. Press "W", "A", "S" and "D" keys on the keyboard to fine tune the position of the selected mark. The index of selected mark will be shown on the right of image. By default, none of the marks is selected, and the index should be zero. When you click on a mark or drag it, the mark will be selected. When you zone in, if selected mark is not within the zone in range then it will be deselect.
4. Use"Q" and "E" on the keyboard to perform "Save" + "Previous" button function and "Save" + "Next" button function.
5. Use "Turn to Page" function to fast index to certain page.
6. Use "DELETE" button to delete current image and label. (Warning: the delete is permanent.)

##### JSON
A simple function `mat2json.m` is provided in case you want to read the label file with other language.
