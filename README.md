# SeeTurgor
SeeTurgor is to gain insights into the arrangement of turgidity in a
multicellular tissue. It aims to provide rounded toolboxes for post analysis,
after measured various sets of on-site turgor pressures of cells neighbored in
random directions and photographed homorganic tissue sections. SeeTurgor first
performs turgor prediction at any tangent plane of a plant meristem by utilizing
an [FCN] based model to segment cell walls, cooperating with genetic algorithm to 
generate an optimal cell wall patterned graph solution that satisfies the problem's 
statement: the data set extracted from the graph is at highest similar with experimental measurements. Then,
abstract the layer-based turgor characters with breadth-first search algorithm,
followed by 3-D modeling.

The repository contains code for cell wall morphological segmentation, medial
axis transform, genetic algorithm, Breadth-first search algorithm, turgor
simulation in dome-shaped meristem in MATLAB and Python.

# Requirements: 
The code requires MATLAB2016a, python 3.6 as well as the
following python libraries:

-   OpenCV
-   matplotlib
-   numpy
-   Pillow
-   scipy
-   commentjson

CorelDRAW is also needed for vectorization and manually tracing the fuzzy parts
of cell walls that are out the limit of artificial intelligence (i.e., FCN) to
recognize.

# Tutorial

**A.	Trace Cell Contours in Microphotographs by Utilizing A Fully Convolutional Network (FCN) Based Model**

1.  Call function *imagecut.m* to cut the paired, same sized **demo.png** and
    **label.png** to small images with same rules. We selected 12 demo.png
    images in advance. Each has \>100 cells. We labeled cell walls manually
    using lines in corelDRAW.

2.  Run *edge2red.py* to change the label lines of the images cut from the
    **label.png** to red color, forming **label set**.

3.  Run *RGB2grayscale.py* to change the RGB images cut from the **demo.png** to
    grayscale, 3-channel images, forming **demo set**.

4.  Gather **label set** and **demo set** together forming **training set**.

5.  Train the *FCN* based model on the **training set** as [described], outputting **trained model**.

6.  Run *RGB2grayscale.py* to change the RGB-mode **candidate.png** to
    grayscale, 3-channel images, outputting **g_candidate.png.**

7.  Let the **trained model** read **g_candidate.png**, outputting
    **reference.png**.

8.  Run *Skeletonization.py* to reduce foreground regions in **reference.png**
    to a skeletal remnant, outputting **sk_reference.png**.

9. Vectorize **de_reference.png** in CorelDRAW X6, complement the gaps manually
    by referencing the **candidate.png**, and save cell boundaries structured at
    0.2 mm thickness lines as the name of **data.png**. Pay attention to the
    relative size of cells in **data.png**.

**B.  Number Cells and Obtain Coordinate Values of Cell Boundaries**

10. Run *GetCentra.m* to number cells by clicking the mouse at any point of a
    cell, by using **demo.png** as input and calling *circleplot.m*. Output
    **Data2.mat** and **centre.xlsx**.

11. Run *GetBound.m* to trace cell boundaries of **demo.png** using
    **Data2.mat** and **centre.xlsx** as inputs. Output **Bound4Cell.mat**.

12. Run *visualization.m* to visualize and check traced cells and their numbers.
    Output **show.fig**.

**C.  Modeling by Utilizing Genetic Algorithm And Determined Normalized Turgor Data**

   **13a. FOR ONE-PART MODELLING**

   i.  Run *ExtractInformation2.m* to build the framework for Genetic Algorithm by
    using **Data2.mat**, **Centre.mat**, **Bound4Cell.mat** and **WT98 1 + 0.5
    modelling data.xlsx** as inputs, and calling *getPoint.m*. Output
    **prepare.mat**.

   ii.  Run *mainFun.m* to genetically evolve by using **prepare.mat** as input and
    calling *myga5.m* which further calls *fitFun.m*. Output **figures** showing
    process, evolutionary_record and result, and **ColorAllocation.mat**. Save
    **result.fig**.

   **13b. FOR Three-PART MODELLING**

   i.  Run *cal4divide.m* (which calls *visualization.m* which uses **Data2.mat**,
    **Centre.mat** and **Bound4Cell.mat** as inputs) with pre-opened
    **show.fig** to divide cells to three groups with two point-point lines, by
    clicking the mouse and using **Centre.mat** as input. Output **select.xlsx**
    and **select.mat**.

   ii.  Run *visualization4divide.m* to visualize and check the divided result,
    using **Data2.mat**, **Centre.mat**, **Bound4Cell.mat** and **select.xlsx**
    as inputs.

   iii.  Run *ExtractInformation3.m* to build the framework for Genetic Algorithm
    using **Centre.mat**, **Bound4Cell.mat** and **modeling_data.xlsx** and
    **select.xlsx** as inputs, subsequently calling **refresh.m**. Output
    **prepare.mat**.

   iv.  Run *mainfun-re.m* to genetically evolve by using **preapare.mat** and
    **select.xlsx** as inputs and calling *new-maya5.m* (which calls
    *fitfun.m*), *relativePath.m*, *GetColorAllocation.m*, *new-showbest.m* and
    *Remove0_5.m*. Output **figures** showing process, evolutionary_record and
    result, and **finalColorAllocation.mat**. Save **result.fig**.

**D.  Delete undetected paths and edit pictures**

14.  Run **FixFig.m** with pre-opened **result.fig**. Optional: save the
    outputted image as publish.fig for publishing.

**E.  Obtain Layer-Based Turgor Profile in Apical Meristem Slices**

15.  Run *GeneratePathSet(20170505).py* to categorize cells to different layers
    using **prepare.mat** as input. Output **Leval.mat** and **all the correct
    path2.xlsx**, and also print all the correct path in the command window
    (Leval 1 corresponds to L2, Leval 2 corresponds to L3, and…).

16.  Run *GeneratePathSet4.py* to categorize cells to different layers and read
    cell turgor properties using **prepare.mat** and
    **FinalColorAllocation.mat** as inputs. Output **Leval.mat**, **all the
    correct path4.xlsx** and **values and colors4.xlsx** which are both also
    printed in the command window.

17.  Run *check_result.m* to check the layered pattern using **Data2.mat**,
    **Centre.mat**, **Bound4Cell.mat** and **Leval.mat** as inputs. Output
    **Layer.fig** as reference.

**F.  3-D Turgor Modelling**

18.  Run *Pro_3D_14.m* to build a dome simulating a meristem with two stacks of
    7-layer cells using **data2.xlsx** as input and calling *getSphere.m*,
    *FW.m* and *FindWays4.m*. Output a 3-D model, **3D.fig**.
    
[FCN]: https://arxiv.org/abs/1612.07695
[described]: https://github.com/gaskinwang/KittiSeg
