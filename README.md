# SlideSeg3

Author: Brendan Crabb <brendancrabb8388@pointloma.edu> <br>
Modified Sep 12, 2019 <br>
<hr>

Welcome to SlideSeg3, a python3 module modified from SlideSeg that allows you to segment whole slide images into usable image
chips for deep learning. Image masks for each chip are generated from associated markup and annotation files.

If you use this code for research purposes, please cite the following in your paper: 

Brendan Crabb, Niels Olson, "SlideSeg: a Python module for the creation of annotated image repositories from whole slide images", Proc. SPIE 10581, Medical Imaging 2018: Digital Pathology, 105811C (6 March 2018); doi: 10.1117/12.2300262; https://doi.org/10.1117/12.2300262


## Usage <a class ="anchor" id="user-guide"></a>
1.    [Environment](#1.)  
2.    [Setup](#2.)  
      2.1 [Parameters](#2.1)  
      2.2 [Annotation Key](#2.2)  
3.    [Run](#3.)
4.    [References](#4.)

### 1. Environment <a class ="anchor" id="1."></a>

Go to main directory

##### 1.1 Creating environment from .yml file <a class ="anchor" id="1.1"></a>

<code>conda env create -f environment_slideseg3.yml </code>

Creating the environment might take a few minutes. Once finished, issue the following command to activate the environment:

* Windows: <code>activate SlideSeg3</code>
* macOS and Linux: <code>source activate SlideSeg3</code>

If the environment was activated successfully, you should see (SlideSeg3) at the beggining of the command prompt.

OpenSlide and OpenCV are C libraries; as a result, they have to be installed separately from the conda environment, which contains all of the python dependencies.

### 2. Setup <a class ="anchor" id="2."></a>

Create a folder called 'images/' in the main directory and copy all of the slide images into this folder. Create a folder called 'xml/' in the main directory copy the markup and annotation files (in .xml format) into this folder. It is important that the annotation files have the same file name as the slide they are associated with.

##### 2.1 Parameters <a class ="anchor" id="2.1"></a>

Set parameters in Parameters.txt

<p style="margin-left: 40px">
<b>slide_path:</b> Path to the folder of slide images <br>

<b>xml_path:</b> Path to the folder of xml files <br>

<b>output_dir:</b> Path to the output folder where image_chips, image_masks, and text_files will be saved <br>

<b>format:</b> Output format of the image_chips and image_masks (png or jpg only) <br>

<b>quality:</b> Output quality: JPEG compression if output format is 'jpg' (100 recommended,jpg compression artifacts will distort image segmentation) <br>

<b>size:</b> Size of image_chips and image_masks in pixels <br>

<b>overlap:</b> Pixel overlap between image chips <br>

<b>key:</b> The text file containing annotation keys and color codes <br>

<b>save_all:</b> True saves every image_chip, False only saves chips containing an annotated pixel <br>

<b>save_ratio:</b> Ratio of image_chips containing annotations to image_chips not containing annotations (use 'inf' if only annotated chips are desired; only applicable if save_all == False <br>

<b>level:</b> Choose from highest (highest magnification), all, lowest (lowest magnification), 40.0, 20.0, 10.0, 5.0, 2.5, 1.25
if no specific magnification created by manufactory will use lower magnification. e.g 40x->20x <br>

<b>cpus:</b> Number of CPUs to be used to parallel multiple WSIs, if processing all levels, less then 4 cpus will be recommanded in case of memory lack.

</p>

##### 2.2 Annotation Key <a class ="anchor" id="2.2"></a>

   The main directory should already contain an Annotation_Key.txt file. If no Annotation_Key file is present, one will be generated automatically from the annotation files in the xml folder.<br>

   The Annotation_Key file contains every annotation key with its associated color code. In all image masks, annotations with that key will have the specified pixel value.  If an unknown key is encountered, it will be given a pixel value and added to the Annotation_Key automatically. <br>

### 3. Run <a class ="anchor" id="3."></a>
Once in SlideSeg3 environment, run the python script 'main.py'. Jupter notebook will be supported later.

### 4. References <a class ="anchor" id="4."></a>
https://github.com/btcrabb/SlideSeg

### 5. Biowulf script
  Go to SlideSeg3 directory

  Assume your data located at "/data/$USER/images" and "/data/$USER/xml"

  Output will be created at 
  "/data/$USER/SlideSeg3-Job id" after job done

```console
  sbatch \
      --gres=lscratch:200 \
      --cpus-per-task=8 \
      --mem=200g \
      --time=1440 \
      process.sh \
          /data/$USER/images \
          /data/$USER/xml
```