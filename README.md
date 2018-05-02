**Requirements**: The code requires MATLAB2016a, python 3.6 as well as the
following python libraries:

-   OpenCV

-   matplotlib

-   numpy

-   Pillow

-   scipy

-   commentjson

**Tutorial**

1.  **Trace cell contours in microphotographs by utilizing a Fully Convolutional
    Network (FCN) based model**

2.  Run *imagecut.m* to cut the paired, same sized **demo.png** and
    **label.png** to small images with same rules.

3.  Run *edge2red.py* to change the label lines of the images cut from the
    **label.png** to red color, forming the labeling set.

4.  Run *trun_gray.py* to change the RGB images cut from the **demo.png** to
    grayscale, 3-channel images, forming the demo set.

5.  Gather the labeling set and the demo set together forming the **training
    set**.

6.  Train the *FCN* based model on the **training set** as described
    <https://github.com/gaskinwang/KittiSeg>, outputting the **trained model**.

7.  Run *grayscale.py* to change the RGB-mode **candidate.png** to grayscale,
    3-channel images, outputting **g_candidate.png**

8.  Let the **trained model** read **g_candidate.png**, outputting
    **reference.png**.

9.  Run *edge.py* to denoise the **reference.png**, outputting
    **de_reference.png**.

10. Vectorize the **de_reference.png** in CorelDRAW X6, complement the gaps by
    referencing the **candidate.png**, and save cell boundaries structured at
    0.2 mm thickness lines as the name of **data.png**. Pay attention to the
    relative size of cells in **data.png**.
